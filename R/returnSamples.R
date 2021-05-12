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
#' @return when `dataType = "relative_abundance"`, a
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object is returned; otherwise, a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' object is returned
#' @export
#'
#' @examples
#' sampleMetadata %>%
#'     dplyr::filter(age >= 18) %>%
#'     dplyr::filter(!base::is.na(alcohol)) %>%
#'     dplyr::filter(body_site == "stool") %>%
#'     dplyr::select(where(~ !base::all(base::is.na(.x)))) %>%
#'     returnSamples("relative_abundance")
#'
#' @importFrom magrittr %>%
#' @importFrom stringr str_c
#' @importFrom SummarizedExperiment colData
#' @importFrom tibble column_to_rownames
#' @importFrom S4Vectors DataFrame
returnSamples <- function(sampleMetadata, dataType, counts = FALSE) {
    if (base::is.null(sampleMetadata[["study_name"]])) {
        stop("study_name must be present in sampleMetadata", call. = FALSE)
    }

    if (base::is.null(sampleMetadata[["sample_id"]])) {
        stop("sample_id must be present in sampleMetadata", call. = FALSE)
    }

    to_return <-
        base::unique(sampleMetadata[["study_name"]]) %>%
        stringr::str_c(dataType, sep = ".") %>%
        stringr::str_c(collapse = "|") %>%
        curatedMetagenomicData(dryrun = FALSE, counts = counts) %>%
        mergeData()

    keep_rows <-
        base::rownames(to_return)

    to_return <-
        to_return[keep_rows, sampleMetadata[["sample_id"]]]

    SummarizedExperiment::colData(to_return) <-
        tibble::column_to_rownames(sampleMetadata, var = "sample_id") %>%
        S4Vectors::DataFrame()

    to_return
}
