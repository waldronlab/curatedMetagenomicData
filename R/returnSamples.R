#' Title
#'
#' Description
#'
#' @param sampleMetadata description
#' @param dataType description
#' @param counts description
#'
#' @return description
#' @export
#'
# @examples
# sampleMetadata %>%
#     dplyr::filter(age <= 8) %>%
#     dplyr::select(where(~ !base::all(base::is.na(.x)))) %>%
#     returnSamples("marker_presence")
#
#' @importFrom magrittr %>%
#' @importFrom stringr str_c
#' @importFrom SummarizedExperiment colData
#' @importFrom S4Vectors DataFrame
returnSamples <- function(sampleMetadata, dataType, counts = FALSE) {
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
        S4Vectors::DataFrame(sampleMetadata)

    to_return
}
