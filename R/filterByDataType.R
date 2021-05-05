#' filterByDataType
#'
#' Merge multiple filtered studies by the same dataType. If the dataType is
#' `relative_abundance` then a `TreeSummerizedExperiment` is returned;
#' otherwise, the function returns a `SummerizedExperiment`
#'
#' @param metadata data.frame of filtered metadata
#' @param dataType string for `gene_families`, `marker_abundance`,
#'                 `marker_presence`, `pathway_abundance`, `pathway_coverage`,
#'                 `relative_abundance`
#'
#' @return `SummarizedExperiment` or `TreeSummarizedExperiment`
#' @export
#'
#' @examples
#' dplyr::filter(sampleMetadata,
#'               age >= 30,
#'               age <= 40,
#'               smoker == "yes") %>%
#'     filterByDataType("marker_presence")
#'
#' dplyr::filter(sampleMetadata,
#'               age == 40,
#'               smoker == "yes",
#'               gender == "male") %>%
#'     filterByDataType("marker_presence")
#'
#' dplyr::filter(sampleMetadata,
#'               disease == "fatty_liver",
#'               age_category == "adult") %>%
#'     filterByDataType("relative_abundance")
#'
#' @importFrom dplyr filter
#' @importFrom magrittr %>%
filterByDataType <- function(metadata, dataType) {
    mergedStudies <- unique(unlist(metadata$studyName, use.names = FALSE)) %>%
        paste(dataType, sep = ".") %>%
        sapply(curatedMetagenomicData, dryrun = FALSE) %>%
        mergeData()
    return(mergedStudies[ , metadata$sampleID])
}
