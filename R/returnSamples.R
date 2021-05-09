#' Return Samples Across Studies
#'
#' Description
#'
#' @param sampleMetadata description
#'
#' @param dataType description
#'
#' @param counts description
#'
#' @return description
#' @export
#'
# @examples
#'
#' @importFrom magrittr %>%
#' @importFrom stringr str_c
#' @importFrom SummarizedExperiment colData
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

    col_names <-
        SummarizedExperiment::colData(to_return) %>%
        base::colnames()

    keep_cols <-
        base::colnames(sampleMetadata) %>%
        base::intersect(col_names)

    SummarizedExperiment::colData(to_return) <-
        SummarizedExperiment::colData(to_return)[sampleMetadata[["sample_id"]], keep_cols]

    to_return
}
