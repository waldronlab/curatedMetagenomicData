#' Return Samples Across Studies
#'
#' To return samples across studies, users will use `returnSamples()` along with
#' the [sampleMetadata] `data.frame` subset to include only desired samples and
#' metadata. The subset [sampleMetadata] `data.frame` will be used to get the
#' desired resources, [mergeData] will be used to merge them, and the subset
#' [sampleMetadata] `data.frame` will be used again to subset the
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class] or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object to include only desired samples and metadata.
#'
#' At present, curatedMetagenomicData resources exists only as entire studies
#' which requires potentially getting many resources for a limited number of
#' samples. Furthermore, because it is necessary to use [mergeData] internally,
#' the same caveats detailed under **Details** in [mergeData] apply here.
#'
#' @param sampleMetadata the [sampleMetadata] `data.frame` subset to include
#' only desired samples and metadata
#'
#' @param dataType the data type to be returned; one of the following:
#' * `"gene_families"`
#' * `"marker_abundance"`
#' * `"marker_presence"`
#' * `"pathway_abundance"`
#' * `"pathway_coverage"`
#' * `"relative_abundance"`
#'
#' @param counts if `FALSE` (the default), relative abundance proportions are
#' returned; if `TRUE`, relative abundance proportions are multiplied by read
#' depth and rounded to the nearest integer prior to being returned
#'
#' @param rownames the type of `rownames` to use for `relative_abundance`
#' resources, one of: `"long"` (the default, the full MetaPhlAn clade string),
#' `"short"` (species name), or
#' `"NCBI"` (NCBI Taxonomy ID). These are different
#' vocabularies; see the Taxonomic names section of [curatedMetagenomicData]
#' before merging with profiles generated elsewhere.
#'
#' @return when `dataType = "relative_abundance"`, a
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object is returned; otherwise, a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' object is returned
#' @export
#'
#' @examples
#' sampleMetadata |>
#'     dplyr::filter(age >= 18) |>
#'     dplyr::filter(!base::is.na(alcohol)) |>
#'     dplyr::filter(body_site == "stool") |>
#'     dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
#'     returnSamples("relative_abundance")
#'
#' @importFrom dplyr select
#' @importFrom rlang .data
#' @importFrom dplyr add_count
#' @importFrom dplyr mutate
#' @importFrom dplyr pull
#' @importFrom stringr str_c
#' @importFrom SummarizedExperiment colData<-
#' @importFrom dplyr filter
#' @importFrom tibble column_to_rownames
#' @importFrom S4Vectors DataFrame
#' @importFrom purrr map
#' @importFrom SummarizedExperiment colData
returnSamples <- function(sampleMetadata, dataType, counts = FALSE, rownames = "long") {
    if (is.null(sampleMetadata[["study_name"]])) {
        stop("study_name must be present in sampleMetadata", call. = FALSE)
    }

    if (is.null(sampleMetadata[["sample_id"]])) {
        stop("sample_id must be present in sampleMetadata", call. = FALSE)
    }

    requested <-
        split(sampleMetadata[["sample_id"]], sampleMetadata[["study_name"]])

    sampleMetadata[["sample_id"]] <-
        select(sampleMetadata, "sample_id", "study_name") |>
        add_count(.data[["sample_id"]]) |>
        mutate(sample_id = ifelse(.data[["n"]] > 1, paste(.data[["sample_id"]], .data[["study_name"]], sep = "."), .data[["sample_id"]])) |>
        pull(.data[["sample_id"]])

    to_return <-
        unique(sampleMetadata[["study_name"]]) |>
        str_c(dataType, sep = ".") |>
        str_c(collapse = "|") |>
        curatedMetagenomicData(dryrun = FALSE, counts = counts, rownames = rownames) |>
        map(.keep_requested, requested = requested) |>
        mergeData()

    keep_rows <-
        rownames(to_return)

    col_names <-
        colnames(to_return) |>
        intersect(sampleMetadata[["sample_id"]])

    if (length(sampleMetadata[["sample_id"]]) != length(col_names)) {
        drop_text <-
            as.character("dropping columns without assay matches:\n")

        drop_cols <-
            setdiff(sampleMetadata[["sample_id"]], col_names) |>
            str_c(collapse = ", ")

        if (dataType == "relative_abundance") {
            message(drop_text, "  ", drop_cols, "\n")
        } else {
            message("\n", drop_text, "  ", drop_cols, "\n")
        }

        ## in sampleMetadata order, to line up with the colData set below
        keep_cols <-
            intersect(sampleMetadata[["sample_id"]], col_names)
    } else {
        keep_cols <-
            sampleMetadata[["sample_id"]]
    }

    to_return <-
        to_return[keep_rows, keep_cols]

    colData(to_return) <-
        filter(sampleMetadata, .data[["sample_id"]] %in% keep_cols) |>
        column_to_rownames(var = "sample_id") |>
        DataFrame()

    to_return
}

## Keep only the requested samples of one study, so that mergeData() works on
## the samples asked for rather than on every sample of every study.
.keep_requested <- function(x, requested) {
    study <- unique(as.character(colData(x)[["study_name"]]))
    wanted <- unlist(requested[study], use.names = FALSE)
    x[, colnames(x) %in% wanted]
}
