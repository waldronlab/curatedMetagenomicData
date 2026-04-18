#' Access Curated Metagenomic Data
#'
#' To access curated metagenomic data users will use `curatedMetagenomicData()`
#' after "shopping" the [harmonized_meta] `data.frame` for resources they are
#' interested in. The `dryrun` argument allows users to perfect a query prior
#' to returning resources. When `dryrun = TRUE`, matched resources will be
#' printed before they are returned invisibly as a character vector. When
#' `dryrun = FALSE`, a `list` of resources containing
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' and/or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' objects, each with the corresponding harmonized sample metadata, is
#' returned. Multiple resources can be returned simultaneously. Finally, if a
#' `relative_abundance` resource is requested and `counts = TRUE`, relative
#' abundance proportions will be multiplied by read depth and rounded to the
#' nearest integer.
#'
#' Starting with curatedMetagenomicData 4.0 ("cMD4"), resources are served
#' from the published cMD4 DuckDB catalog of hive-partitioned parquet files
#' produced by `curatedMetagenomicDataETL` rather than from
#' Bioconductor's ExperimentHub. The function signature, the `dryrun`,
#' `counts`, and `rownames` arguments, and the return type are unchanged
#' from cMD3 so existing user code continues to work; the catalog URL can
#' be overridden via `options(curatedMetagenomicData.duckdb_url = ...)`.
#'
#' Resource titles use the cMD3 dotted format `<runDate>.<study_name>.<dataType>`,
#' where `<runDate>` is a fixed cMD4 release tag (the cMD4 ETL produces a
#' single dated snapshot, so the historical "select the most recent date"
#' step is a no-op). The HUMAnN3-derived data types (`gene_families`,
#' `pathway_abundance`, `pathway_coverage`) are not yet available in the
#' cMD4 catalog and currently raise an error if requested.
#'
#' @param pattern regular expression pattern to look for in the titles of
#' resources available in curatedMetagenomicData; `""` will return all
#' resources
#'
#' @param dryrun if `TRUE` (the default), a character vector of resource names
#' is returned invisibly; if `FALSE`, a `list` of resources is returned
#'
#' @param counts if `FALSE` (the default), relative abundance proportions are
#' returned; if `TRUE`, relative abundance proportions are multiplied by read
#' depth and rounded to the nearest integer prior to being returned
#'
#' @param rownames the type of `rownames` to use for `relative_abundance`
#' resources, one of: `"long"` (the default), `"short"` (species name), or
#' `"NCBI"` (NCBI Taxonomy ID)
#'
#' @return if `dryrun = TRUE`, a character vector of resource names is returned
#' invisibly; if `dryrun = FALSE`, a `list` of resources is returned
#' @export
#'
#' @seealso [mergeData], [returnSamples], [harmonized_meta], [all_meta]
#'
#' @examples
#' curatedMetagenomicData("AsnicarF_20.+")
#'
#' \dontrun{
#'   curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
#'
#'   curatedMetagenomicData("AsnicarF_20.+.relative_abundance",
#'                          dryrun = FALSE, counts = TRUE)
#' }
#'
#' @importFrom stringr str_subset str_c
#' @importFrom DBI dbDisconnect
#' @importFrom dplyr filter
#' @importFrom rlang .data
curatedMetagenomicData <- function(pattern, dryrun = TRUE,
                                   counts = FALSE, rownames = "long") {
    if (missing(pattern)) {
        stop("the pattern argument is missing", call. = FALSE)
    }
    rownames <- match.arg(rownames, c("long", "short", "NCBI"))

    titles <- .cmd_resource_titles()
    matched <- str_subset(titles, pattern)

    if (length(matched) == 0L) {
        stop("no resources available in curatedMetagenomicData",
             call. = FALSE)
    }

    if (dryrun) {
        message(str_c(matched, collapse = "\n"))
        return(invisible(matched))
    }

    ## Resolve <runDate>.<study>.<dataType> for each matched title.
    parts <- .cmd_split_titles(matched)
    resource_list <- vector("list", length(matched))
    names(resource_list) <- matched

    con <- .cmd_connect()
    on.exit(try(DBI::dbDisconnect(con, shutdown = TRUE), silent = TRUE),
            add = TRUE)

    for (i in seq_len(nrow(parts))) {
        study   <- parts[[i, "study_name"]]
        dtype   <- parts[[i, "data_type"]]
        label   <- matched[[i]]

        meta_i <- dplyr::filter(
            curatedMetagenomicData::harmonized_meta,
            .data[["study_name"]] == study
        )
        if (nrow(meta_i) == 0L) {
            stop("no samples found in harmonized_meta for study '",
                 study, "'.", call. = FALSE)
        }

        ## Drop columns that are entirely NA after subsetting (cMD3 behavior).
        meta_i <- meta_i[, vapply(meta_i, function(x) !all(is.na(x)),
                                  logical(1L)), drop = FALSE]
        sample_ids <- as.character(meta_i[["sample_id"]])
        meta_i <- as.data.frame(meta_i, stringsAsFactors = FALSE)
        rownames(meta_i) <- sample_ids

        assay_mat <- .cmd_load_assay(
            con          = con,
            dataType     = dtype,
            sample_names = sample_ids
        )

        resource_list[[i]] <- .cmd_build_assay_object(
            assay_mat      = assay_mat,
            colData_df     = meta_i,
            dataType       = dtype,
            counts         = counts,
            rownames       = rownames,
            resource_label = label,
            message_first  = (i == 1L)
        )
    }

    resource_list
}

## ---- internal helpers used by curatedMetagenomicData() --------------------

## Build the canonical list of cMD4 resource titles. The cMD4 catalog is a
## single ETL snapshot, so we use the package release date as a fixed
## `<runDate>` to keep the cMD3 dotted-title format intact. Studies come
## from `harmonized_meta`; data types come from the cMD4 data dictionary.
.cmd_resource_titles <- function() {
    studies <- sort(unique(
        as.character(curatedMetagenomicData::harmonized_meta[["study_name"]])
    ))
    dtypes  <- .cmd_data_types()[["data_type"]]
    rundate <- .cmd_run_date()
    as.vector(outer(
        studies, dtypes,
        FUN = function(s, d) paste(rundate, s, d, sep = ".")
    ))
}

## Fixed cMD4 ETL snapshot tag used as the runDate prefix in resource
## titles. Override via `options(curatedMetagenomicData.run_date = ...)`.
.cmd_run_date <- function() {
    getOption("curatedMetagenomicData.run_date", default = "cmd4")
}

## Split a vector of dotted resource titles into runDate / study_name /
## data_type columns. The runDate may itself contain hyphens but no dots,
## so a strsplit on "." is unambiguous.
.cmd_split_titles <- function(titles) {
    pieces <- strsplit(titles, ".", fixed = TRUE)
    bad <- vapply(pieces, function(x) length(x) != 3L, logical(1L))
    if (any(bad)) {
        stop("malformed resource title(s): ",
             paste(titles[bad], collapse = ", "), call. = FALSE)
    }
    data.frame(
        runDate    = vapply(pieces, `[[`, character(1L), 1L),
        study_name = vapply(pieces, `[[`, character(1L), 2L),
        data_type  = vapply(pieces, `[[`, character(1L), 3L),
        stringsAsFactors = FALSE
    )
}
