#' Download Metadata/Data for Any/All Studies in curatedMetagenomicData
#'
#' `curatedMetagenomicData()` is a simplified interface to what was previously a
#' rather complicated way to access data in the package. Users should first look
#' through the `metadata`, which has information about every sample currently
#' available in `curatedMetagenomicData` (and those that are forthcoming), to
#' "shop" for a study they would like to download. Then, a query to access data
#' can be perfected while `dryrun = TRUE` because it only returns metadata.
#' Finally, `dryrun` can be set to `FALSE` and a `SummarizedExperiment` object
#' will be returned.
#'
#' @param x regular expression(s) to be matched against curatedMetagenomicData;
#' if multiple, they are combined by logical `&`
#'
#' @param dryrun `logical` indicating if the user would like to return metadata
#' (the default); when set to `FALSE` a `SummarizedExperiment` is returned
#'
#' @param counts `logical` indicating if the user would like to return data as
#' relative abundances (the default); or return data as counts
#'
#' @return a `data.frame` of ExperimentHub metadata when `dryrun = TRUE`, and a
#' `SummarizedExperiment` when `dryrun = FALSE`
#' @export
#'
#' @examples
#' curatedMetagenomicData(x = "AsnicarF_2017.marker_presence")
#'
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom ExperimentHub listResources
#' @importFrom stringr str_starts
#' @importFrom magrittr extract
#' @importFrom stringr str_split
#' @importFrom magrittr equals
#' @importFrom stringr str_c
#' @importFrom AnnotationHub query
#' @importFrom magrittr %>%
#' @importFrom S4Vectors mcols
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
curatedMetagenomicData <- function(x = "", dryrun = TRUE, counts = FALSE) {
    EH <-
        ExperimentHub::ExperimentHub()

    resources <-
        ExperimentHub::listResources(EH, "curatedMetagenomicData", filterBy = x)

    versioned <-
        stringr::str_starts(resources, "[0-9]")

    resources <-
        magrittr::extract(resources, versioned)

    is_matrix <-
        stringr::str_split(resources, "\\.") %>%
        base::sapply(base::length) %>%
        magrittr::equals(3)

    resources <-
        magrittr::extract(resources, is_matrix)

    if (base::length(resources) == 0) {
        stop("No resources found in curatedMetagenomicData", call. = FALSE)
    }

    if (dryrun) {
        resources <-
            stringr::str_c(resources, collapse = "|")

        to_return <-
            AnnotationHub::query(EH, resources) %>%
            S4Vectors::mcols() %>%
            base::as.data.frame()

        keep_rows <-
            base::rownames(to_return)

        keep_cols <-
            base::c("title", "description", "rdataclass")

        to_return <-
            magrittr::extract(to_return, keep_rows, keep_cols)

        return(to_return)
    }

    resources <-
        stringr::str_c(resources, collapse = "|")

    to_return <-
        AnnotationHub::query(EH, resources)

    to_subset <-
        S4Vectors::mcols(to_return)

    keep_rows <-
        base::rownames(to_subset)

    into_cols <-
        base::c("dateAdded", "studyName", "dataType")

    resources <-
        magrittr::extract(to_subset, keep_rows, "title", drop = FALSE) %>%
        tibble::as_tibble(rownames = "rowname") %>%
        tidyr::separate(.data[["title"]], into_cols, sep = "\\.") %>%
        dplyr::group_by(.data[["studyName"]], .data[["dataType"]]) %>%
        dplyr::slice_max(.data[["dateAdded"]]) %>%
        dplyr::ungroup()

    if (base::nrow(resources) != 1) {
        stop("Only a single resource should be loaded", call. = FALSE)
    }

    eh_subset <-
        dplyr::pull(resources, .data[["rowname"]])

    eh_matrix <-
        to_return[[eh_subset]]

    keep_cols <-
        base::colnames(eh_matrix)

    meta_data <-
        dplyr::filter(curatedMetagenomicData::metadata, .data[["studyName"]] == resources[["studyName"]]) %>%
        tibble::column_to_rownames(var = "sampleID") %>%
        dplyr::select(where(~ base::all(!base::is.na(.x))))

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
