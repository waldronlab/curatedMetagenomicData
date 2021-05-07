#' Access Curated Metagenomic Data
#'
#' To access curated metagenomic data users will use `curatedMetagenomicData()`,
#' after "shopping" the [sample metadata][sampleMetadata] for studies they are
#' interested in. The `dryrun` argument allows users to perfect a query prior to
#' (down)loading a data set. When `dryrun = TRUE`, the names of matched data
#' sets will be printed nicely before a character vector of names is returned
#' invisibly. When`dryrun = FALSE`, a (sparse) matrix is (down)loaded and used
#' to construct a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class] or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object with corresponding metadata from [sample metadata][sampleMetadata].
#' If there is more than one date corresponding to the data set, the more recent
#' one is selected automatically. Finally, if a `relative_abundance` data set is
#' requested with `counts = TRUE`, relative abundance proportions will be
#' multiplied by read depth (i.e. `number_reads`) and rounded to the nearest
#' integer prior to being returned as a
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object with corresponding metadata from [sample metadata][sampleMetadata].
#'
#' @param pattern regular expression pattern to look for in the titles of
#' resources available in curatedMetagenomicData; `""` will return all resources
#'
#' @param dryrun if `TRUE` (the default), a character vector of resource names
#' is returned invisibly; if `FALSE`, a `SummarizedExperiment` is returned
#'
#' @param counts if `FALSE` (the default), relative abundance proportions are
#' returned; if `TRUE`, relative abundance proportions are multiplied by read
#' depth and rounded to the nearest integer prior to being returned
#'
#' @return if `dryrun = TRUE`, a character vector of resource names is returned
#' invisibly; if `dryrun = FALSE`, a `list` is returned
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
#' @importFrom purrr list_along
#' @importFrom magrittr set_names
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
#' @importFrom TreeSummarizedExperiment TreeSummarizedExperiment
#' @importFrom SummarizedExperiment SummarizedExperiment
curatedMetagenomicData <- function(pattern, dryrun = TRUE, counts = FALSE) {
    if (base::missing(pattern)) {
        stop("Thou shalt not search for nothing", call. = FALSE)
    }

    resources <-
        stringr::str_subset(title, pattern)

    if (base::length(resources) == 0) {
        stop("No resources found in curatedMetagenomicData", call. = FALSE)
    }

    if (dryrun) {
        base::cat(resources, sep = "\n")

        return(base::invisible(resources))
    }

    resource_list <-
        purrr::list_along(resources) %>%
        magrittr::set_names(resources)

    resources <-
        stringr::str_c(resources, collapse = "|")

    to_return <-
        ExperimentHub::ExperimentHub() %>%
        AnnotationHub::query(resources)

    to_subset <-
        S4Vectors::mcols(to_return)

    keep_rows <-
        base::rownames(to_subset)

    into_cols <-
        base::c("date_added", "study_name", "data_type")

    resources <-
        magrittr::extract(to_subset, keep_rows, "title", drop = FALSE) %>%
        tibble::as_tibble(rownames = "rowname") %>%
        tidyr::separate(.data[["title"]], into_cols, sep = "\\.") %>%
        dplyr::group_by(.data[["study_name"]], .data[["data_type"]]) %>%
        dplyr::slice_max(.data[["date_added"]]) %>%
        dplyr::ungroup()

    resource_index <-
        base::nrow(resources) %>%
        base::seq_len()

    for (i in resource_index) {
        eh_subset <-
            resources[[i, "rowname"]]

        eh_matrix <-
            base::suppressMessages(to_return[[eh_subset]])

        row_names <-
            base::rownames(eh_matrix)

        meta_data <-
            dplyr::filter(curatedMetagenomicData::sampleMetadata, .data[["study_name"]] == resources[[i, "study_name"]]) %>%
            tibble::column_to_rownames(var = "sample_id") %>%
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
            eh_matrix <-
                base::t(eh_matrix) %>%
                magrittr::multiply_by(colData[["number_reads"]]) %>%
                magrittr::divide_by(100) %>%
                base::t() %>%
                base::round()
        }

        assays <-
            S4Vectors::SimpleList(eh_matrix)

        base::names(assays) <-
            resources[[i, "data_type"]]

        if (resources[[i, "data_type"]] == "relative_abundance") {
            # TODO row_tree = phylogeneticTree[[row_names]] to remove warning

            resource_list[[i]] <-
                TreeSummarizedExperiment::TreeSummarizedExperiment(assays = assays, colData = colData, rowTree = phylogeneticTree)
        } else {
            resource_list[[i]] <-
                SummarizedExperiment::SummarizedExperiment(assays = assays, colData = colData)
        }
    }

    return(resource_list)
}
