#' Title
#'
#' Description
#'
#' @param x a list
#'
#' @return a `SummarizedExperiment` is returned
#' @export
#'
#' @examples
#' curatedMetagenomicData("AsnicarF_20.+.pathway_abundance", dryrun = FALSE) %>%
#'     mergeData()
#'
#' curatedMetagenomicData("AsnicarF_20.+.relative_abundance", dryrun = FALSE) %>%
#'     mergeData()
#'
#' @importFrom purrr map_chr
#' @importFrom magrittr %>%
#' @importFrom purrr map
#' @importFrom SummarizedExperiment assay
#' @importFrom tibble rownames_to_column
#' @importFrom purrr reduce
#' @importFrom dplyr full_join
#' @importFrom tibble column_to_rownames
#' @importFrom S4Vectors SimpleList
#' @importFrom magrittr set_names
#' @importFrom SummarizedExperiment rowData
#' @importFrom S4Vectors DataFrame
#' @importFrom SummarizedExperiment colData
#' @importFrom dplyr bind_rows
#' @importFrom TreeSummarizedExperiment TreeSummarizedExperiment
#' @importFrom SummarizedExperiment SummarizedExperiment
mergeData <- function(x) {
    assay_name <-
        purrr::map_chr(x, SummarizedExperiment::assayNames) %>%
        base::unique()

    if (base::length(assay_name) != 1) {
        stop("Different assay types can not be combined", call. = FALSE)
    }

    assays <-
        purrr::map(x, SummarizedExperiment::assay) %>%
        purrr::map(base::as.data.frame) %>%
        purrr::map(tibble::rownames_to_column) %>%
        purrr::reduce(dplyr::full_join, by = "rowname") %>%
        tibble::column_to_rownames() %>%
        base::as.matrix() %>%
        S4Vectors::SimpleList() %>%
        magrittr::set_names(assay_name)

    rowData <-
        purrr::map(x, SummarizedExperiment::rowData) %>%
        purrr::map(base::as.data.frame) %>%
        purrr::map(tibble::rownames_to_column) %>%
        purrr::reduce(dplyr::full_join, by = "rowname") %>%
        tibble::column_to_rownames() %>%
        S4Vectors::DataFrame()

    colData <-
        purrr::map(x, SummarizedExperiment::colData) %>%
        purrr::map(base::as.data.frame) %>%
        purrr::map(tibble::rownames_to_column) %>%
        dplyr::bind_rows() %>%
        tibble::column_to_rownames() %>%
        S4Vectors::DataFrame()

    if (assay_name == "relative_abundance") {
        TreeSummarizedExperiment::TreeSummarizedExperiment(assays = assays, rowData = rowData, colData = colData, rowTree = phylogeneticTree)
    } else {
        SummarizedExperiment::SummarizedExperiment(assays = assays, rowData = rowData, colData = colData)
    }
}
