#' Return Samples Across Studies
#'
#' To return a cohort of samples selected across studies, users filter the
#' [harmonized_meta] (or [all_meta]) `data.frame` to the samples and columns
#' of interest and then pass the subset to `returnSamples()`. The function
#' assembles a feature x sample matrix from the cMD4 backend, attaches the
#' filtered metadata as `colData`, and returns a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' (or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' for `relative_abundance`).
#'
#' Starting with curatedMetagenomicData 4.0 the data backend is a published
#' DuckDB catalog of hive-partitioned parquet files produced by
#' `curatedMetagenomicDataETL`. The catalog is queried on demand and the
#' transition from the cMD3 ExperimentHub backend is intentionally
#' transparent: the function signature, the `counts` and `rownames`
#' arguments, and the return type are unchanged from cMD3.
#'
#' @param sampleMetadata a `data.frame` filtered to the samples of interest,
#'   typically a subset of [harmonized_meta] or [all_meta]. Must contain
#'   `sample_id` and `study_name` columns.
#' @param dataType the data type to return; one of `"relative_abundance"`,
#'   `"marker_abundance"`, `"marker_presence"`, `"marker_rel_ab_w_read_stats"`,
#'   or `"viral_clusters"`. (HUMAnN3-derived data types -- `gene_families`,
#'   `pathway_abundance`, `pathway_coverage` -- are not yet available in
#'   the cMD4 catalog and currently raise an error.)
#' @param counts if `FALSE` (the default), relative abundance proportions are
#'   returned; if `TRUE`, relative abundance proportions are multiplied by
#'   read depth and rounded to the nearest integer. Only applies to
#'   `relative_abundance`; ignored for other data types.
#' @param rownames the type of `rownames` to use for `relative_abundance`
#'   results, one of `"long"` (the default), `"short"` (species name), or
#'   `"NCBI"` (NCBI Taxonomy ID). Ignored for other data types.
#'
#' @return A
#'   [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#'   (or
#'   [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#'   for `relative_abundance`) whose `colData` is the filtered
#'   `sampleMetadata` (rows aligned to the assay columns) and whose assay
#'   is named after `dataType`.
#' @export
#'
#' @seealso [curatedMetagenomicData], [mergeData], [harmonized_meta],
#'   [all_meta]
#'
#' @examples
#' \dontrun{
#'   library(curatedMetagenomicData)
#'   library(dplyr)
#'
#'   harmonized_meta |>
#'       filter(age_years >= 18) |>
#'       filter(!is.na(bmi)) |>
#'       filter(body_site == "feces") |>
#'       returnSamples("relative_abundance", rownames = "short")
#' }
#'
returnSamples <- function(sampleMetadata, dataType,
                          counts = FALSE, rownames = "long") {
    if (!is.data.frame(sampleMetadata)) {
        stop("'sampleMetadata' must be a data.frame.", call. = FALSE)
    }
    if (is.null(sampleMetadata[["sample_id"]])) {
        stop("'sampleMetadata' must contain a 'sample_id' column.",
             call. = FALSE)
    }
    if (is.null(sampleMetadata[["study_name"]])) {
        stop("'sampleMetadata' must contain a 'study_name' column.",
             call. = FALSE)
    }
    rownames <- match.arg(rownames, c("long", "short", "NCBI"))

    sample_ids <- as.character(sampleMetadata[["sample_id"]])
    if (anyDuplicated(sample_ids)) {
        stop("'sampleMetadata$sample_id' must be unique; filter the table ",
             "first.", call. = FALSE)
    }

    coldata_df <- as.data.frame(sampleMetadata, stringsAsFactors = FALSE)
    rownames(coldata_df) <- sample_ids

    con <- .cmd_connect()
    on.exit(.cmd_disconnect(con), add = TRUE)

    assay_mat <- .cmd_load_assay(
        con          = con,
        dataType     = dataType,
        sample_names = sample_ids
    )

    .cmd_build_assay_object(
        assay_mat      = assay_mat,
        colData_df     = coldata_df,
        dataType       = dataType,
        counts         = counts,
        rownames       = rownames,
        resource_label = NULL,
        message_first  = TRUE
    )
}
