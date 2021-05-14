#' Merge curatedMetagenomicData List
#'
#' To merge the `list` elements returned from [curatedMetagenomicData] into a
#' single
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class] or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object, users will use `mergeData()` provided elements are the same
#' `dataType` (see [returnSamples]). This is useful for analysis across entire
#' studies (e.g. meta-analysis); however, when doing analysis across individual
#' samples (e.g. mega-analysis) [returnSamples] is preferable.
#'
#' Internally, `mergeData()` must full join `assays` and `rowData` slots of each
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class] or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object (`colData` is merged slightly more efficiently by row binding). While
#' `dplyr` methods are used for maximum efficiency, users should be aware that
#' memory requirements can be large when merging many `list` elements.
#'
#' @param mergeList a `list` returned from [curatedMetagenomicData] where all of
#' the elements are of the same `dataType` (see [returnSamples])
#'
#' @return when `mergeList` elements are of `dataType` (see [returnSamples])
#' `relative_abundance`, a
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object is returned; otherwise, a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' object is returned
#' @export
#'
#' @seealso [curatedMetagenomicData], [returnSamples]
#'
#' @examples
#' curatedMetagenomicData("LiJ_20.+.marker_abundance", dryrun = FALSE) %>%
#'     mergeData()
#'
#' curatedMetagenomicData("LiJ_20.+.pathway_abundance", dryrun = FALSE) %>%
#'     mergeData()
#'
#' curatedMetagenomicData("LiJ_20.+.relative_abundance", dryrun = FALSE) %>%
#'     mergeData()
#'
#' @importFrom purrr map_chr
#' @importFrom magrittr %>%
#' @importFrom purrr map
#' @importFrom purrr reduce
#' @importFrom SummarizedExperiment assay
#' @importFrom tibble rownames_to_column
#' @importFrom dplyr full_join
#' @importFrom tibble column_to_rownames
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom tidyr replace_na
#' @importFrom S4Vectors SimpleList
#' @importFrom magrittr set_names
#' @importFrom SummarizedExperiment rowData
#' @importFrom S4Vectors DataFrame
#' @importFrom SummarizedExperiment colData
#' @importFrom dplyr bind_rows
#' @importFrom TreeSummarizedExperiment TreeSummarizedExperiment
#' @importFrom SummarizedExperiment SummarizedExperiment
mergeData <- function(mergeList) {
    if (base::length(mergeList) == 1) {
        stop("mergeList contains only a single element", call. = FALSE)
    }

    assay_name <-
        purrr::map_chr(mergeList, SummarizedExperiment::assayNames) %>%
        base::unique()

    if (base::length(assay_name) != 1) {
        stop("dataType of list elements is different", call. = FALSE)
    }

    duplicate_colnames <-
        purrr::map(mergeList, base::colnames) %>%
        purrr::reduce(base::intersect)

    if (base::length(duplicate_colnames) != 0) {
        stop("colnames/sample_id values are not unique", call. = FALSE)
    }

    assays <-
        purrr::map(mergeList, SummarizedExperiment::assay) %>%
        purrr::map(base::as.data.frame) %>%
        purrr::map(tibble::rownames_to_column) %>%
        purrr::reduce(dplyr::full_join, by = "rowname") %>%
        tibble::column_to_rownames() %>%
        dplyr::mutate(dplyr::across(.fns = ~ tidyr::replace_na(.x, 0))) %>%
        base::as.matrix() %>%
        S4Vectors::SimpleList() %>%
        magrittr::set_names(assay_name)

    rowData <-
        purrr::map(mergeList, SummarizedExperiment::rowData) %>%
        purrr::map(base::as.data.frame) %>%
        purrr::map(tibble::rownames_to_column)

    join_by <-
        purrr::map(rowData, base::colnames) %>%
        purrr::reduce(base::intersect)

    rowData <-
        purrr::reduce(rowData, dplyr::full_join, by = join_by) %>%
        tibble::column_to_rownames() %>%
        S4Vectors::DataFrame()

    colData <-
        purrr::map(mergeList, SummarizedExperiment::colData) %>%
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
