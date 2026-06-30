### cMD4 access layer (internal) ----------------------------------------------
###
### The cMD4 backend serves sample-level profiling data from a published
### DuckDB catalog of hive-partitioned parquet files produced by the
### `curatedMetagenomicDataETL` pipeline. The catalog exposes one
### `src_*` view per data type, all sharing the join columns
### `sample_id`, `sample_name`, `run_ids`, and `study_name`. The
### harmonized `sample_id` matches the ETL `sample_name` column.
###
### Starting with curatedMetagenomicData 4.0.1 the DuckDB plumbing,
### lazy filtering, long-to-wide assembly, and experiment merging are
### delegated to the `curatedCore` package. The helpers below are thin
### CMD-specific adapters that (a) describe the catalog as a
### `curatedCore::CuratedSource`, (b) build a `curatedCore::SchemaSpec`
### from `inst/extdata/cmd4_data_types.csv`, and (c) supply the
### relative_abundance-specific `finalize` hook (row tree, taxonomy,
### counts conversion, and short/NCBI relabeling) that reproduces cMD3
### semantics exactly.
###
### To keep the cMD4 transition transparent for the existing user base,
### the DuckDB plumbing is intentionally not exported: the user-facing
### API remains `curatedMetagenomicData()`, `returnSamples()`, and
### `mergeData()` (plus the `harmonized_meta` / `all_meta` data objects).
### The helpers below are private and may change between releases.

## ---- catalog discovery ----------------------------------------------------

.cmd_data_url <- function() {
    getOption(
        "curatedMetagenomicData.duckdb_url",
        default = "https://minio.cancerdatasci.org/cmgd-export/cmgd.duckdb"
    )
}

.cmd_data_types <- function() {
    fpath <- .cmd_data_types_path()
    utils::read.csv(fpath, stringsAsFactors = FALSE)
}

.cmd_data_types_path <- function() {
    fpath <- system.file(
        "extdata", "cmd4_data_types.csv",
        package = "curatedMetagenomicData"
    )
    if (!nzchar(fpath)) {
        stop("cmd4_data_types.csv not found in installed package.",
             call. = FALSE)
    }
    fpath
}

.cmd_lookup_spec <- function(dataType) {
    spec_tbl <- .cmd_data_types()
    row <- spec_tbl[spec_tbl$data_type == dataType, , drop = FALSE]
    if (nrow(row) == 0L) {
        stop(
            "Unknown dataType '", dataType, "'. Available in the cMD4 ",
            "catalog: ", paste(spec_tbl$data_type, collapse = ", "),
            call. = FALSE
        )
    }
    as.list(row[1L, ])
}

## ---- curatedCore source and schema ----------------------------------------

## Open a DuckDB connection to the cMD4 catalog via curatedCore. Replaces the
## former `.cmd_connect()`; the S3/httpfs configuration and the read-only
## ATTACH are handled by curatedCore::connectSource().
.cmd_connect <- function(db_url = .cmd_data_url()) {
    curatedCore::duckdbCatalogSource(db_url, alias = "cmgd") |>
        curatedCore::connectSource()
}

## Build a curatedCore::SchemaSpec from the cMD4 data dictionary. CMD's
## catalog join column is `sample_name` (matches harmonized_meta$sample_id).
## The CSV's `feature_col` / `value_col` columns map directly onto the
## schema's feature column and single (data-type-named) assay column; rowData
## and colData columns are empty (CMD supplies colData externally).
.cmd_schema <- function() {
    curatedCore::readSchemaSpec(
        .cmd_data_types_path(),
        id_col = "sample_name"
    )
}

## ---- (Tree)SummarizedExperiment assembly ----------------------------------

## Lookup `number_reads` for a vector of sample_ids from `all_meta`. Used to
## reconstruct integer count assays when `counts = TRUE`. Returns a numeric
## vector aligned to `sample_ids` (NA when not found).
.cmd_number_reads <- function(sample_ids) {
    am <- curatedMetagenomicData::all_meta
    if (!"number_reads" %in% colnames(am)) {
        stop("`number_reads` is not available in `all_meta`; cannot ",
             "reconstruct counts.", call. = FALSE)
    }
    idx <- match(sample_ids, am[["sample_id"]])
    as.numeric(am[["number_reads"]])[idx]
}

## Construct the `relative_abundance` finalize hook for
## curatedCore::buildExperiment(). The returned closure takes the bare
## TreeSummarizedExperiment built by curatedCore (assay + colData, no row
## tree) and applies cMD3 semantics: filter rows to `phylogeneticTree`
## tips, attach a row tree, attach taxonomy `rowData`, optionally convert
## proportions to integer counts, and relabel rownames (short / NCBI). All
## `message()` calls (dropped rows) match the pre-refactor output exactly.
##
## For non-relative_abundance data types the caller passes `finalize = NULL`
## (plain SummarizedExperiment), as before.
#' @importFrom S4Vectors SimpleList DataFrame
#' @importFrom SummarizedExperiment SummarizedExperiment rowData rowData<-
#' @importFrom SummarizedExperiment assay colData assayNames
#' @importFrom TreeSummarizedExperiment TreeSummarizedExperiment rownames<-
#' @importFrom mia taxonomyRankEmpty getTaxonomyLabels
#' @importFrom magrittr extract
#' @importFrom stringr str_subset
.cmd_finalize_ra <- function(counts = FALSE, rownames = "long",
                             resource_label = NULL, message_first = TRUE) {
    function(se) {
        assay_mat <- SummarizedExperiment::assay(se, 1L)
        keep_cols <- colnames(assay_mat)

        ## Restore cMD3 feature ordering: the former `.cmd_load_assay()`
        ## pivot ordered features by a C-locale (radix) sort of the feature
        ## ids (an artifact of dplyr::group_by). Reproduce it here so the
        ## row order is identical to the pre-refactor result.
        row_names <- rownames(assay_mat)
        row_names <- row_names[order(row_names, method = "radix")]
        keep_tips <- intersect(row_names, phylogeneticTree[["tip.label"]])

        drop_rows <- setdiff(row_names, keep_tips) |>
            str_subset("s__") |>
            sort()

        if (length(drop_rows) != 0L) {
            msg <- "dropping rows without rowTree matches:\n"
            if (!is.null(resource_label)) {
                msg <- paste0("$`", resource_label, "`\n", msg)
            }
            msg <- paste0(msg, paste0("  ", drop_rows, collapse = "\n"), "\n")
            if (message_first) msg <- paste0("\n", msg)
            message(msg)
        }

        assay_mat <- assay_mat[keep_tips, keep_cols, drop = FALSE]

        ## counts conversion (cMD3 semantics): proportion * read_depth / 100
        if (isTRUE(counts)) {
            nreads <- .cmd_number_reads(keep_cols)
            if (anyNA(nreads)) {
                warning(
                    "`number_reads` missing in `all_meta` for ",
                    sum(is.na(nreads)), " sample(s); their count assay ",
                    "values will be NA.", call. = FALSE
                )
            }
            assay_mat <- t(t(assay_mat) * nreads / 100)
            assay_mat <- round(assay_mat)
            storage.mode(assay_mat) <- "integer"
        }

        colData <- SummarizedExperiment::colData(se)[keep_cols, , drop = FALSE]
        assays  <- S4Vectors::SimpleList(assay_mat)
        names(assays) <- SummarizedExperiment::assayNames(se)[1L]

        tse <- TreeSummarizedExperiment::TreeSummarizedExperiment(
            assays  = assays,
            colData = colData,
            rowTree = phylogeneticTree
        )

        keep_ranks <- c(
            "superkingdom", "phylum", "class", "order",
            "family", "genus", "species"
        )

        if (rownames == "NCBI") {
            SummarizedExperiment::rowData(tse) <-
                magrittr::extract(rowDataNCBI, keep_tips, keep_ranks)
        } else {
            SummarizedExperiment::rowData(tse) <-
                magrittr::extract(rowDataLong, keep_tips, keep_ranks)
        }

        if (rownames != "long") {
            ## Remove taxa without taxonomy information so getTaxonomyLabels
            ## can build short labels (mirrors cMD3 behavior).
            wo_taxonomy <- mia::taxonomyRankEmpty(tse)
            if (any(wo_taxonomy)) {
                drop_rows <- rownames(tse)[wo_taxonomy]
                msg <- "dropping rows without taxonomy info:\n"
                if (!is.null(resource_label)) {
                    msg <- paste0("$`", resource_label, "`\n", msg)
                }
                msg <- paste0(
                    msg, paste0("  ", drop_rows, collapse = "\n"), "\n"
                )
                if (message_first) msg <- paste0("\n", msg)
                message(msg)
                tse <- tse[!wo_taxonomy, ]
            }
            rownames(tse) <- mia::getTaxonomyLabels(tse)
        }

        tse
    }
}

## Retrieve one data type for a set of sample_ids and assemble it into a
## (Tree)SummarizedExperiment via curatedCore. `colData_df` must be a
## data.frame whose rownames are sample_ids (which equal the catalog's
## `sample_name`). This replaces the former `.cmd_load_assay()` +
## `.cmd_build_assay_object()` pair.
##
## For relative_abundance, a TreeSE is built and the cMD3-specific finalize
## hook is applied. For other data types a plain SE is returned.
##
## `resource_label` is used in messages (e.g. "$`<title>`") and is optional.
#' @importFrom SummarizedExperiment colData colData<- assay assayNames
#' @importFrom SummarizedExperiment rowData rowData<-
.cmd_assemble <- function(con, dataType, colData_df,
                          counts = FALSE, rownames = "long",
                          resource_label = NULL, message_first = TRUE) {
    spec      <- .cmd_lookup_spec(dataType)
    view_name <- spec$view_name
    schema    <- .cmd_schema()

    sample_ids <- rownames(colData_df)

    ## curatedCore keys colData on the schema id_col (`sample_name`); supply
    ## a matching key column while preserving the original metadata columns.
    col_data <- colData_df
    col_data[["sample_name"]] <- sample_ids

    lazy <- curatedCore::filterView(
        con, view_name,
        filter_values = list(sample_name = unique(as.character(sample_ids))),
        schema = schema
    )
    table <- curatedCore::collectView(lazy, notify = FALSE)

    is_ra <- identical(dataType, "relative_abundance")

    ## The "dropping columns without assay matches" message (samples present
    ## in metadata but absent from the catalog view) is emitted here so it is
    ## identical to the pre-refactor behavior, including ordering relative to
    ## the row-dropping messages produced inside the finalize hook.
    present <- unique(as.character(table[["sample_name"]]))
    missing_samples <- setdiff(sample_ids, present)
    if (length(missing_samples) > 0L) {
        msg <- "dropping columns without assay matches:\n"
        if (!is.null(resource_label)) {
            msg <- paste0("$`", resource_label, "`\n", msg)
        }
        msg <- paste0(
            msg, paste0("  ", missing_samples, collapse = "\n"), "\n"
        )
        if (message_first && !is_ra) {
            msg <- paste0("\n", msg)
        }
        message(msg)
    }
    if (length(present) == 0L) {
        stop("No samples matched the cMD4 view for dataType = '",
             dataType, "'.", call. = FALSE)
    }

    finalize <- if (is_ra) {
        .cmd_finalize_ra(
            counts = counts, rownames = rownames,
            resource_label = resource_label, message_first = message_first
        )
    } else {
        NULL
    }
    experiment_class <- if (is_ra) {
        "TreeSummarizedExperiment"
    } else {
        "SummarizedExperiment"
    }

    se <- curatedCore::buildExperiment(
        table = table,
        schema = schema,
        data_type = dataType,
        col_data = col_data,
        experiment_class = experiment_class,
        finalize = finalize
    )

    ## Restore cMD3 feature ordering for non-relative_abundance experiments.
    ## (The relative_abundance finalize hook already reorders its rows.) The
    ## former `.cmd_load_assay()` pivot ordered features by a C-locale (radix)
    ## sort of the feature ids. Also drop the feature_col that curatedCore
    ## records in rowData: cMD3 non-relative_abundance objects carried no
    ## rowData columns.
    if (!is_ra) {
        rn <- rownames(se)
        se <- se[order(rn, method = "radix"), , drop = FALSE]
        rd <- SummarizedExperiment::rowData(se)
        rd[[spec$feature_col]] <- NULL
        SummarizedExperiment::rowData(se) <- rd
    }

    ## Drop the synthetic join key so colData matches the input metadata
    ## (rownames remain the sample_ids set by curatedCore).
    cd <- SummarizedExperiment::colData(se)
    cd[["sample_name"]] <- NULL
    SummarizedExperiment::colData(se) <- cd
    se
}
