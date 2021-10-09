#' Access Curated Metagenomic Data
#'
#' To access curated metagenomic data users will use `curatedMetagenomicData()`
#' after "shopping" the [sampleMetadata] `data.frame` for resources they are
#' interested in. The `dryrun` argument allows users to perfect a query prior to
#' returning resources. When `dryrun = TRUE`, matched resources will be printed
#' before they are returned invisibly as a character vector. When
#' `dryrun = FALSE`, a `list` of resources containing
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' and/or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' objects, each with corresponding sample metadata, is returned. Multiple
#' resources can be returned simultaneously and if there is more than one date
#' corresponding to a resource, the most recent one is selected automatically.
#' Finally, if a `relative_abundance` resource is requested and `counts = TRUE`,
#' relative abundance proportions will be multiplied by read depth and rounded
#' to the nearest integer.
#'
#' Above "resources" refers to resources that exists in Bioconductor's
#' ExperimentHub service. In the context of curatedMetagenomicData, these are
#' study-level (sparse) matrix objects used to create
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' and/or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' objects that are ultimately returned as the `list` of resources. Only the
#' `gene_families` `dataType` (see [returnSamples]) is stored as a sparse matrix
#' in ExperimentHub - this has no practical consequences for users and is done
#' to optimize storage. When searching for "resources", users will use the
#' `study_name` value from the [sampleMetadata] `data.frame`.
#'
#' @param pattern regular expression pattern to look for in the titles of
#' resources available in curatedMetagenomicData; `""` will return all resources
#'
#' @param dryrun if `TRUE` (the default), a character vector of resource names
#' is returned invisibly; if `FALSE`, a `list` of resources is returned
#'
#' @param counts if `FALSE` (the default), relative abundance proportions are
#' returned; if `TRUE`, relative abundance proportions are multiplied by read
#' depth and rounded to the nearest integer prior to being returned
#'
#' @return if `dryrun = TRUE`, a character vector of resource names is returned
#' invisibly; if `dryrun = FALSE`, a `list` of resources is returned
#' @export
#'
#' @seealso [mergeData], [returnSamples], [sampleMetadata]
#'
#' @examples
#' curatedMetagenomicData("AsnicarF_20.+")
#'
#' curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
#'
#' curatedMetagenomicData("AsnicarF_20.+.relative_abundance", dryrun = FALSE, counts = TRUE)
#'
#' @importFrom stringr str_subset
#' @importFrom stringr str_c
#' @importFrom purrr list_along
#' @importFrom magrittr set_names
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
    if (missing(pattern)) {
        stop("the pattern argument is missing", call. = FALSE)
    }

    resources <-
        str_subset(title, pattern)

    if (length(resources) == 0) {
        stop("no resources available in curatedMetagenomicData", call. = FALSE)
    }

    if (dryrun) {
        str_c(resources, collapse = "\n") |>
            message()

        return(invisible(resources))
    }

    resource_list <-
        list_along(resources) |>
        set_names(resources)

    resources <-
        str_c(resources, collapse = "|")

    to_return <-
        ExperimentHub() |>
        query(resources)

    to_subset <-
        mcols(to_return)

    keep_rows <-
        rownames(to_subset)

    into_cols <-
        c("date_added", "study_name", "data_type")

    resources <-
        extract(to_subset, keep_rows, "title", drop = FALSE) |>
        as_tibble(rownames = "rowname") |>
        separate(.data[["title"]], into_cols, sep = "\\.") |>
        group_by(.data[["study_name"]], .data[["data_type"]]) |>
        slice_max(.data[["date_added"]]) |>
        ungroup()

    resource_index <-
        nrow(resources) |>
        seq_len()

    resource_names <-
        names(resource_list)

    for (i in resource_index) {
        eh_subset <-
            resources[[i, "rowname"]]

        eh_matrix <-
            suppressMessages(to_return[[eh_subset]])

        row_names <-
            rownames(eh_matrix)

        meta_data <-
            filter(curatedMetagenomicData::sampleMetadata, .data[["study_name"]] == resources[[i, "study_name"]]) |>
            column_to_rownames(var = "sample_id") |>
            select(where(~ !all(is.na(.x))))

        meta_rows <-
            rownames(meta_data)

        keep_cols <-
            colnames(eh_matrix) |>
            intersect(meta_rows)

        eh_matrix <-
            extract(eh_matrix, row_names, keep_cols)

        col_names <-
            colnames(meta_data)

        colData <-
            extract(meta_data, keep_cols, col_names) |>
            DataFrame()

        if (resources[[i, "data_type"]] == "relative_abundance") {
            keep_tips <-
                intersect(row_names, phylogeneticTree[["tip.label"]])

            drop_rows <-
                setdiff(row_names, keep_tips) |>
                str_subset("s__") |>
                sort()

            if (length(drop_rows) != 0) {
                drop_name <-
                    str_c("$`", resource_names[[i]], "`\n")

                drop_text <-
                    as.character("dropping rows without rowTree matches:\n")

                drop_rows <-
                    str_c("  ", drop_rows, collapse = "\n")

                if (i == 1) {
                    message("\n", drop_name, drop_text, drop_rows, "\n")
                } else {
                    message(drop_name, drop_text, drop_rows, "\n")
                }
            }

            eh_matrix <-
                extract(eh_matrix, keep_tips, keep_cols)

            if (counts) {
                eh_matrix <-
                    t(eh_matrix) |>
                    multiply_by(colData[["number_reads"]]) |>
                    divide_by(100) |>
                    t() |>
                    round()

                mode(eh_matrix) <-
                    "integer"
            }

            assays <-
                SimpleList(eh_matrix)

            names(assays) <-
                resources[[i, "data_type"]]

            tax_names <-
                c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

            rowData <-
                data.frame(rowname = keep_tips) |>
                separate(.data[["rowname"]], tax_names, sep = "\\|", remove = FALSE, fill = "right") |>
                mutate(across(.cols = -"rowname", .fns = ~ str_remove_all(.x, "[a-z]__"))) |>
                mutate(across(.cols = -"rowname", .fns = ~ str_replace_all(.x, "_", " "))) |>
                column_to_rownames() |>
                DataFrame()

            resource_list[[i]] <-
                TreeSummarizedExperiment(assays = assays, rowData = rowData, colData = colData, rowTree = phylogeneticTree)
        } else {
            assays <-
                SimpleList(eh_matrix)

            names(assays) <-
                resources[[i, "data_type"]]

            resource_list[[i]] <-
                SummarizedExperiment(assays = assays, colData = colData)
        }
    }

    resource_list
}
