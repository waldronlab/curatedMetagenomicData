#' Access Curated Metagenomic Data
#'
#' Description
#'
#' @param pattern description
#'
#' @param dryrun description
#'
#' @param counts description
#'
#' @return description
#' @export
#'
# @examples
#'
#' @importFrom stringr str_subset
#' @importFrom purrr list_along
#' @importFrom magrittr %>%
#' @importFrom magrittr set_names
#' @importFrom stringr str_c
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom AnnotationHub query
#' @importFrom S4Vectors mcols
#' @importFrom magrittr extract
#' @importFrom tibble as_tibble
#' @importFrom tidyr separate
#' @importFrom rlang .data
#' @importFrom dplyr group_by
#' @importFrom dplyr slice_max
#' @importFrom dplyr ungroup
#' @importFrom dplyr filter
#' @importFrom tibble column_to_rownames
#' @importFrom dplyr select
#' @importFrom magrittr extract
#' @importFrom S4Vectors DataFrame
#' @importFrom magrittr multiply_by
#' @importFrom magrittr divide_by
#' @importFrom S4Vectors SimpleList
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom stringr str_remove_all
#' @importFrom stringr str_replace_all
#' @importFrom TreeSummarizedExperiment TreeSummarizedExperiment
#' @importFrom SummarizedExperiment SummarizedExperiment
curatedMetagenomicData <- function(pattern, dryrun = TRUE, counts = FALSE) {
    if (base::missing(pattern)) {
        stop("the pattern argument is missing", call. = FALSE)
    }

    resources <-
        stringr::str_subset(title, pattern)

    if (base::length(resources) == 0) {
        stop("no resources found in curatedMetagenomicData", call. = FALSE)
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

        if (resources[[i, "data_type"]] == "relative_abundance") {
            keep_tips <-
                base::intersect(row_names, phylogeneticTree[["tip.label"]])

            eh_matrix <-
                magrittr::extract(eh_matrix, keep_tips, keep_cols)

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

            tax_names <-
                base::c("kingdom", "phylum", "class", "order", "family", "genus", "species")

            rowData <-
                base::data.frame(rowname = keep_tips) %>%
                tidyr::separate(rowname, tax_names, sep = "\\|", remove = FALSE, fill = "right") %>%
                dplyr::mutate(dplyr::across(.cols = -rowname, .fns = ~ stringr::str_remove_all(.x, "[a-z]__"))) %>%
                dplyr::mutate(dplyr::across(.cols = -rowname, .fns = ~ stringr::str_replace_all(.x, "_", " "))) %>%
                tibble::column_to_rownames() %>%
                S4Vectors::DataFrame()

            resource_list[[i]] <-
                TreeSummarizedExperiment::TreeSummarizedExperiment(assays = assays, rowData = rowData, colData = colData, rowTree = phylogeneticTree)
        } else {
            assays <-
                S4Vectors::SimpleList(eh_matrix)

            base::names(assays) <-
                resources[[i, "data_type"]]

            resource_list[[i]] <-
                SummarizedExperiment::SummarizedExperiment(assays = assays, colData = colData)
        }
    }

    resource_list
}
