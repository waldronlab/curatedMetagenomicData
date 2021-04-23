#' Access Curated Metagenomic Data
#'
#' To access curated metagenomic data users will use `curatedMetagenomicData()`,
#' after "shopping" the [sample metadata][sampleMetadata] for studies they are
#' interested in. The `dryrun` argument allows users to perfect a query prior to
#' (down)loading a data set. When `dryrun = TRUE` and `print = TRUE`, the names
#' of matched data sets will be printed nicely before a character vector of
#' names is returned invisibly. When `dryrun = TRUE` and `print = FALSE`, only
#' the invisible character vector of names is returned. The later behavior is
#' useful in the context of [lapply][base::lapply()] and [map][purrr::map()]
#' functions to (down)load multiple data sets without messages. When
#' `dryrun = FALSE`, a (sparse) matrix is (down)loaded and used to construct a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' object with corresponding metadata from [sample metadata][sampleMetadata].
#' If there is more than one date corresponding to the data set, the more recent
#' one is selected automatically. Finally, if a `relative_abundance` data set is
#' requested with `counts = TRUE`, relative abundance proportions will be
#' multiplied by read depth (i.e. `number_reads`) and rounded to the nearest
#' integer prior to being returned as a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' object with corresponding metadata from [sample metadata][sampleMetadata].
#'
#' @param pattern regular expression pattern to look for in the titles of
#' resources available in curatedMetagenomicData; `""` will return all resources
#'
#' @param dryrun if `TRUE` (the default), a character vector of resource names
#' is returned invisibly; if `FALSE`, a `SummarizedExperiment` is returned
#'
#' @param print if `TRUE` (the default), resource names will be printed nicely
#' before a character vector of resource names is returned invisibly; if
#' `FALSE`, only a character vector of resource names is returned invisibly
#'
#' @param counts if `FALSE` (the default), relative abundance proportions are
#' returned; if `TRUE`, relative abundance proportions are multiplied by read
#' depth and rounded to the nearest integer prior to being returned
#'
#' @return if `dryrun = TRUE`, a character vector of resource names is returned
#' invisibly; if `dryrun = FALSE`, a `SummarizedExperiment` is returned
#' @export
#'
#' @examples
#' curatedMetagenomicData("2021-04-02")
#'
#' curatedMetagenomicData("AsnicarF_2017")
#'
#' curatedMetagenomicData("AsnicarF_2017.relative_abundance")
#'
#' curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
#'
#' curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, counts = TRUE)
#'
#' @importFrom stringr str_subset
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom stringr str_c
#' @importFrom AnnotationHub query
#' @importFrom S4Vectors mcols
#' @importFrom magrittr extract
#' @importFrom magrittr %>%
#' @importFrom tibble as_tibble
#' @importFrom tidyr separate
#' @importFrom rlang .data
#' @importFrom dplyr group_by
#' @importFrom dplyr slice_max
#' @importFrom dplyr ungroup
#' @importFrom dplyr pull
#' @importFrom dplyr filter
#' @importFrom tibble column_to_rownames
#' @importFrom dplyr select
#' @importFrom S4Vectors DataFrame
#' @importFrom magrittr multiply_by
#' @importFrom magrittr divide_by
#' @importFrom S4Vectors SimpleList
#' @importFrom SummarizedExperiment SummarizedExperiment
curatedMetagenomicData <- function(pattern, dryrun = TRUE, print = TRUE, counts = FALSE) {
    if (base::missing(pattern)) {
        stop("Thou shalt not search for nothing", call. = FALSE)
    }

    resources <-
        stringr::str_subset(Title, pattern)

    if (base::length(resources) == 0) {
        stop("No resources found in curatedMetagenomicData", call. = FALSE)
    }

    if (dryrun) {
        if (print) {
            base::cat(resources, sep = "\n")
        }

        return(base::invisible(resources))
    }

    EH <-
        ExperimentHub::ExperimentHub()

    resources <-
        stringr::str_c(resources, collapse = "|")

    to_return <-
        AnnotationHub::query(EH, resources)

    to_subset <-
        S4Vectors::mcols(to_return)

    keep_rows <-
        base::rownames(to_subset)

    into_cols <-
        base::c("dateAdded", "dataset_name", "dataType")

    resources <-
        magrittr::extract(to_subset, keep_rows, "title", drop = FALSE) %>%
        tibble::as_tibble(rownames = "rowname") %>%
        tidyr::separate(.data[["title"]], into_cols, sep = "\\.") %>%
        dplyr::group_by(.data[["dataset_name"]], .data[["dataType"]]) %>%
        dplyr::slice_max(.data[["dateAdded"]]) %>%
        dplyr::ungroup()

    if (base::nrow(resources) != 1) {
        stop("Only a single resource should be loaded", call. = FALSE)
    }

    eh_subset <-
        dplyr::pull(resources, .data[["rowname"]])

    eh_matrix <-
        to_return[[eh_subset]]

    row_names <-
        base::rownames(eh_matrix)

    meta_data <-
        dplyr::filter(curatedMetagenomicData::sampleMetadata, .data[["dataset_name"]] == resources[["dataset_name"]]) %>%
        tibble::column_to_rownames(var = "sampleID") %>%
        dplyr::select(where(~ base::all(!base::is.na(.x))))

    meta_rows <-
        base::rownames(meta_data)

    keep_cols <-
        base::colnames(eh_matrix) %>%
        base::intersect(meta_rows)

    eh_matrix <-
        magrittr::extract(eh_matrix, row_names, keep_cols)

    col_names <-
        base::colnames(meta_data)

    colData <-
        magrittr::extract(meta_data, keep_cols, col_names) %>%
        S4Vectors::DataFrame()

    if (counts) {
        if (dplyr::pull(resources, .data[["dataType"]]) == "relative_abundance") {
            eh_matrix <-
                base::t(eh_matrix) %>%
                magrittr::multiply_by(colData[["number_reads"]]) %>%
                magrittr::divide_by(100) %>%
                base::t() %>%
                base::round()

        } else {
            warning("Data type can not be made into counts", call. = FALSE)
        }
    }

    assays <-
        S4Vectors::SimpleList(eh_matrix)

    base::names(assays) <-
        dplyr::pull(resources, .data[["dataType"]])

    SummarizedExperiment::SummarizedExperiment(assays = assays, colData = colData)
}
