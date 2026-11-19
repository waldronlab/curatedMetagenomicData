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
#' Internally, `mergeData()` combines the `assays` of each
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class] or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object over the union of their row names, full joins the `rowData`, and row
#' binds the `colData`. The merged assay is a sparse matrix when every element
#' holds one (`gene_families`), as returned by [curatedMetagenomicData], and a
#' dense matrix otherwise; memory requirements can still be large when merging
#' many `list` elements.
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
    if (methods::is(mergeList, "SummarizedExperiment")) {
        return(mergeList)
    }

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
        .merge_assays() |>
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

## Merge feature x sample matrices into one matrix over the union of their row
## names, with 0 where a study lacks a feature (and in place of NA, as before).
## When every study is sparse (gene_families) the result is sparse too.
## Otherwise it is dense, and studies are made dense one at a time, so peak
## memory is the result plus one study.
.merge_assays <- function(mats) {
    features <- unique(unlist(lapply(mats, rownames), use.names = FALSE))
    samples <- unlist(lapply(mats, colnames), use.names = FALSE)

    if (all(vapply(mats, inherits, logical(1L), what = "sparseMatrix"))) {
        return(.merge_sparse_assays(mats, features, samples))
    }

    types <- vapply(mats, function(m) {
        typeof(as.matrix(m[0L, 0L, drop = FALSE]))
    }, character(1L))
    zero <- if (length(unique(types)) == 1L) vector(types[[1L]], 1L) else 0

    merged <- matrix(
        zero, length(features), length(samples),
        dimnames = list(features, samples)
    )

    end <- cumsum(vapply(mats, ncol, integer(1L)))
    for (i in seq_along(mats)) {
        n <- ncol(mats[[i]])
        if (n == 0L) {
            next
        }
        block <- as.matrix(mats[[i]])
        if (anyNA(block)) {
            block[is.na(block)] <- zero
        }
        merged[match(rownames(block), features), seq(end[[i]] - n + 1L, end[[i]])] <- block
    }

    merged
}

## The sparse case: re-index each study's non-zero entries to the merged rows,
## one study at a time, then bind the studies by column.
.merge_sparse_assays <- function(mats, features, samples) {
    blocks <- lapply(mats, function(m) {
        triplet <- Matrix::mat2triplet(m)
        value <- as.numeric(triplet[["x"]])
        value[is.na(value)] <- 0
        Matrix::sparseMatrix(
            i = match(rownames(m), features)[triplet[["i"]]],
            j = triplet[["j"]],
            x = value,
            dims = c(length(features), ncol(m))
        )
    })

    merged <- do.call(cbind, blocks)
    dimnames(merged) <- list(features, samples)
    merged
}
