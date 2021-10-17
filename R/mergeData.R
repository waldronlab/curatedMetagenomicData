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
#' curatedMetagenomicData("LiJ_20.+.marker_abundance", dryrun = FALSE) |>
#'     mergeData()
#'
#' curatedMetagenomicData("LiJ_20.+.pathway_abundance", dryrun = FALSE) |>
#'     mergeData()
#'
#' curatedMetagenomicData("LiJ_20.+.relative_abundance", dryrun = FALSE) |>
#'     mergeData()
#'
#' @importFrom purrr map_chr
#' @importFrom SummarizedExperiment assayNames
#' @importFrom purrr map
#' @importFrom purrr reduce
#' @importFrom magrittr extract
#' @importFrom SummarizedExperiment colData
#' @importFrom dplyr pull
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
#' @importFrom dplyr bind_rows
#' @importFrom TreeSummarizedExperiment rowLinks
#' @importFrom dplyr distinct
#' @importFrom rlang .data
#' @importFrom TreeSummarizedExperiment TreeSummarizedExperiment
#' @importFrom SummarizedExperiment SummarizedExperiment
mergeData <- function(mergeList) {
    if (length(mergeList) == 1) {
        return(mergeList[[1]])
    }

    assay_name <-
        map_chr(mergeList, assayNames) |>
        unique()

    if (length(assay_name) != 1) {
        stop("dataType of list elements is different", call. = FALSE)
    }

    col_names <-
        map(mergeList, colnames) |>
        reduce(c)

    is_duplicated <-
        duplicated(col_names)

    duplicate_colnames <-
        extract(col_names, is_duplicated)

    if (length(duplicate_colnames) != 0) {
        merge_list_index <-
            seq_along(mergeList)

        for (i in merge_list_index) {
            col_name <-
                colnames(mergeList[[i]])

            study_name <-
                colData(mergeList[[i]]) |>
                as.data.frame() |>
                pull("study_name")

            colnames(mergeList[[i]]) <-
                ifelse(col_name %in% duplicate_colnames, paste(col_name, study_name, sep = "."), col_name)
        }
    }

    assays <-
        map(mergeList, assay) |>
        map(as.matrix) |>
        map(as.data.frame) |>
        map(rownames_to_column) |>
        reduce(full_join, by = "rowname") |>
        column_to_rownames() |>
        mutate(across(.fns = ~ replace_na(.x, 0))) |>
        as.matrix() |>
        SimpleList() |>
        set_names(assay_name)

    rowData <-
        map(mergeList, rowData) |>
        map(as.data.frame) |>
        map(rownames_to_column)

    join_by <-
        map(rowData, colnames) |>
        reduce(intersect)

    rowData <-
        reduce(rowData, full_join, by = join_by) |>
        column_to_rownames() |>
        DataFrame()

    colData <-
        map(mergeList, colData) |>
        map(as.data.frame) |>
        map(rownames_to_column) |>
        bind_rows() |>
        column_to_rownames() |>
        DataFrame()

    if (assay_name == "relative_abundance") {
        row_names <-
            rownames(rowData)

        rowNodeLab <-
            map(mergeList, rowLinks) |>
            map(as.data.frame) |>
            map(rownames_to_column) |>
            bind_rows() |>
            distinct(.data[["rowname"]], .keep_all = TRUE) |>
            column_to_rownames() |>
            extract(row_names, "nodeLab")

        TreeSummarizedExperiment(assays = assays, rowData = rowData, colData = colData, rowTree = phylogeneticTree, rowNodeLab = rowNodeLab)
    } else {
        SummarizedExperiment(assays = assays, rowData = rowData, colData = colData)
    }
}
