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
#' Starting with curatedMetagenomicData 4.0.1 the actual merge is delegated to
#' [curatedCore::mergeExperiments()]; `mergeData()` is a thin adapter that
#' first disambiguates duplicate sample (column) names across `list` elements
#' by appending the `study_name`, preserving the historical cMD3 behavior.
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
#' @importFrom purrr map_chr map reduce
#' @importFrom magrittr extract
#' @importFrom SummarizedExperiment assayNames colData
#' @importFrom dplyr pull
mergeData <- function(mergeList) {
    if (length(mergeList) == 1) {
        return(mergeList[[1]])
    }

    assay_name <-
        purrr::map_chr(mergeList, SummarizedExperiment::assayNames) |>
        unique()

    if (length(assay_name) != 1) {
        stop("dataType of list elements is different", call. = FALSE)
    }

    ## Disambiguate duplicate sample (column) names across studies by
    ## suffixing with the study_name (historical cMD3 behavior). This is the
    ## one piece curatedCore::mergeExperiments() does not perform, so the
    ## CMD-side adapter applies it before delegating.
    col_names <-
        purrr::map(mergeList, colnames) |>
        purrr::reduce(c)

    is_duplicated <- duplicated(col_names)
    duplicate_colnames <- magrittr::extract(col_names, is_duplicated)

    if (length(duplicate_colnames) != 0) {
        for (i in seq_along(mergeList)) {
            col_name <- colnames(mergeList[[i]])
            study_name <-
                SummarizedExperiment::colData(mergeList[[i]]) |>
                as.data.frame() |>
                dplyr::pull("study_name")
            colnames(mergeList[[i]]) <-
                ifelse(col_name %in% duplicate_colnames,
                       paste(col_name, study_name, sep = "."), col_name)
        }
    }

    curatedCore::mergeExperiments(mergeList)
}
