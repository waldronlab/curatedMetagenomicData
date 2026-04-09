### cMD4 access layer (internal) ----------------------------------------------
###
### The cMD4 backend serves sample-level profiling data from a published
### DuckDB catalog of hive-partitioned parquet files produced by the
### `curatedMetagenomicDataETL` pipeline. The catalog exposes one
### `src_*` view per data type, all sharing the join columns
### `sample_id`, `sample_name`, `run_ids`, and `study_name`. The
### harmonized `sample_id` matches the ETL `sample_name` column.
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
    fpath <- system.file(
        "extdata", "cmd4_data_types.csv",
        package = "curatedMetagenomicData"
    )
    if (!nzchar(fpath)) {
        stop("cmd4_data_types.csv not found in installed package.",
             call. = FALSE)
    }
    utils::read.csv(fpath, stringsAsFactors = FALSE)
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

## ---- DuckDB connection ----------------------------------------------------

#' @importFrom DBI dbConnect dbExecute
.cmd_connect <- function(db_url = .cmd_data_url(), alias = "cmgd") {
    if (!requireNamespace("duckdb", quietly = TRUE)) {
        stop("Package 'duckdb' is required for cMD4 access.", call. = FALSE)
    }
    con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")
    DBI::dbExecute(con, "INSTALL httpfs; LOAD httpfs;")

    ## When the catalog is served over HTTP(S), its `src_*` views reference
    ## parquet partitions via `s3://` URIs against the same host. Configure
    ## DuckDB's httpfs S3 client so those references resolve back to the
    ## catalog's host instead of AWS.
    scheme_match <- regmatches(
        db_url,
        regexpr("^(https?)://([^/]+)", db_url, ignore.case = TRUE)
    )
    if (length(scheme_match) == 1L) {
        parts <- regmatches(
            scheme_match,
            regexec("^(https?)://([^/]+)", scheme_match, ignore.case = TRUE)
        )[[1L]]
        scheme   <- tolower(parts[2L])
        endpoint <- parts[3L]
        DBI::dbExecute(con, sprintf("SET s3_endpoint='%s';", endpoint))
        DBI::dbExecute(con, "SET s3_url_style='path';")
        DBI::dbExecute(
            con,
            sprintf(
                "SET s3_use_ssl=%s;",
                if (scheme == "https") "true" else "false"
            )
        )
    }

    DBI::dbExecute(
        con,
        sprintf("ATTACH '%s' AS %s (READ_ONLY);", db_url, alias)
    )
    DBI::dbExecute(con, sprintf("USE %s;", alias))
    con
}

## ---- assay retrieval ------------------------------------------------------

#' @importFrom DBI dbListFields
#' @importFrom dplyr tbl filter select collect group_by summarise ungroup
#' @importFrom tidyr pivot_wider
#' @importFrom rlang sym .data :=
.cmd_load_assay <- function(con, dataType, sample_names) {
    spec        <- .cmd_lookup_spec(dataType)
    view_name   <- spec$view_name
    feature_col <- spec$feature_col
    value_col   <- spec$value_col

    view_fields  <- DBI::dbListFields(con, view_name)
    missing_cols <- setdiff(
        c("sample_name", feature_col, value_col),
        view_fields
    )
    if (length(missing_cols) > 0L) {
        stop(
            "View '", view_name, "' is missing expected column(s): ",
            paste(missing_cols, collapse = ", "),
            ". Available columns: ", paste(view_fields, collapse = ", "),
            call. = FALSE
        )
    }

    sample_names <- unique(as.character(sample_names))
    feature_sym  <- rlang::sym(feature_col)
    value_sym    <- rlang::sym(value_col)

    long <- dplyr::tbl(con, view_name) |>
        dplyr::filter(.data$sample_name %in% !!sample_names) |>
        dplyr::select(
            "sample_name",
            feature = !!feature_sym,
            value   = !!value_sym
        ) |>
        dplyr::collect()

    if (nrow(long) == 0L) {
        return(matrix(
            numeric(0), nrow = 0, ncol = 0,
            dimnames = list(character(0), character(0))
        ))
    }

    long$value <- suppressWarnings(as.numeric(long$value))

    ## Duplicate (sample, feature) rows (e.g. when a sample was ingested
    ## multiple times) would break pivot_wider; collapse them by mean.
    agg <- long |>
        dplyr::group_by(.data$feature, .data$sample_name) |>
        dplyr::summarise(value = mean(.data$value, na.rm = TRUE),
                         .groups = "drop")

    wide <- tidyr::pivot_wider(
        agg,
        names_from  = "sample_name",
        values_from = "value",
        values_fill = 0
    )

    feature_ids <- wide[["feature"]]
    mat <- as.matrix(wide[, setdiff(colnames(wide), "feature"), drop = FALSE])
    storage.mode(mat) <- "double"
    rownames(mat) <- feature_ids
    mat
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

## Convert a feature x sample assay matrix into a (Tree)SummarizedExperiment
## that matches cMD3 conventions: TreeSummarizedExperiment with `rowTree`
## and `rowData` for `relative_abundance`, plain SummarizedExperiment for
## the other data types. `counts` and `rownames` only apply to
## `relative_abundance` (cMD3 semantics).
##
## `colData_df` must be a data.frame whose rownames are sample_ids.
##
## `resource_label` is used in messages (e.g. "$`<title>`") and is optional.
##
#' @importFrom S4Vectors SimpleList DataFrame
#' @importFrom SummarizedExperiment SummarizedExperiment rowData rowData<-
#' @importFrom TreeSummarizedExperiment TreeSummarizedExperiment rownames<-
#' @importFrom mia taxonomyRankEmpty getTaxonomyLabels
#' @importFrom magrittr extract
#' @importFrom stringr str_subset str_c
.cmd_build_assay_object <- function(assay_mat, colData_df, dataType,
                                    counts = FALSE, rownames = "long",
                                    resource_label = NULL,
                                    message_first = TRUE) {
    sample_ids <- rownames(colData_df)
    keep_cols  <- intersect(sample_ids, colnames(assay_mat))
    missing_samples <- setdiff(sample_ids, keep_cols)
    if (length(missing_samples) > 0L) {
        msg <- "dropping columns without assay matches:\n"
        if (!is.null(resource_label)) {
            msg <- paste0("$`", resource_label, "`\n", msg)
        }
        msg <- paste0(
            msg,
            paste0("  ", missing_samples, collapse = "\n"), "\n"
        )
        if (message_first && dataType != "relative_abundance") {
            msg <- paste0("\n", msg)
        }
        message(msg)
    }

    if (length(keep_cols) == 0L) {
        stop("No samples matched the cMD4 view for dataType = '",
             dataType, "'.", call. = FALSE)
    }

    assay_mat   <- assay_mat[, keep_cols, drop = FALSE]
    colData_df  <- colData_df[keep_cols, , drop = FALSE]
    rownames(colData_df) <- keep_cols

    if (dataType != "relative_abundance") {
        colData <- S4Vectors::DataFrame(colData_df, check.names = FALSE)
        assays  <- S4Vectors::SimpleList(assay_mat)
        names(assays) <- dataType
        return(SummarizedExperiment::SummarizedExperiment(
            assays = assays, colData = colData
        ))
    }

    ## ---- relative_abundance branch (TreeSE with row tree) -----------------
    row_names <- rownames(assay_mat)
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

    colData <- S4Vectors::DataFrame(colData_df, check.names = FALSE)
    assays  <- S4Vectors::SimpleList(assay_mat)
    names(assays) <- dataType

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
        ## Remove taxa without taxonomy information so getTaxonomyLabels can
        ## build short labels (mirrors cMD3 behavior).
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
