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
#' in ExperimentHub – this has no practical consequences for users and is done
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
#' @param rownames the type of `rownames` to use for `relative_abundance`
#' resources, one of: `"long"` (the default, the full MetaPhlAn clade string),
#' `"short"` (the lowest available taxonomic name, usually species), or
#' `"NCBI"` (NCBI Taxonomy ID). These are different
#' vocabularies; see the Taxonomic names section below before merging with
#' profiles generated elsewhere.
#'
#'
#' @section Taxonomic names:
#'
#' The three `rownames` options do not use the same vocabulary, which matters
#' when merging curatedMetagenomicData with profiles generated elsewhere.
#'
#' `"long"` is the unmodified MetaPhlAn clade string, exactly as it appears in
#' the MetaPhlAn database used to generate the data (`mpa_v30_CHOCOPhlAn_201901`
#' for the MetaPhlAn3 resources here). It matches an external profile exactly
#' when that profile was generated from the same database, so it is the option
#' to use when joining against a `merged_abundance_table`.
#'
#' `"short"` and `"NCBI"` are derived by resolving each clade's NCBI Taxonomy ID
#' against NCBI when the package data are built, so they reflect NCBI taxonomy as
#' of that point rather than the taxonomy frozen in the MetaPhlAn database.
#' Neither is looked up at retrieval time: both are snapshots, refreshed only when
#' the packaged taxonomy is regenerated. Where a taxon was reclassified between
#' the two, the `"short"` name differs from the MetaPhlAn clade name, and such
#' taxa fail to match on a merge by name with no error raised. MetaPhlAn3 reports
#' `Bacteroides_dorei` while `"short"` gives `Phocaeicola_dorei`. This affects
#' about 7% of returned rows, including the 2020 split of `Lactobacillus` across
#' several new genera. Roughly half of the affected rows are phages, which
#' MetaPhlAn names after the host rather than by NCBI's virus genus.
#'
#'
#' `"short"` is the lowest taxonomic name available for a row, which is the
#' species for almost every row but the genus for a handful of MetaPhlAn
#' species groups and complexes that NCBI resolves no further. Those rows are
#' not filtered out, and their presence is why `"NCBI"` row names carry a rank
#' prefix.
#'
#' To join on NCBI Taxonomy ID, use the integer `rowData()` column for the species
#' rank rather than the row names. That column holds identifiers only when the
#' resource was requested with `rownames = "NCBI"`; with `"long"` or `"short"`
#' the same column holds character names. Species identifiers are stable across genus
#' reclassification, but genus identifiers are not: `Bacteroides` is 816 and
#' `Phocaeicola` is 909656, so a genus-level identifier join fails in exactly the
#' way a name join does. Row names produced by `rownames = "NCBI"` are labels
#' rather than bare identifiers and can carry a rank prefix such as `species:`, so
#' they are not directly comparable with identifiers from another source.
#'
#' `rowData()` holds one vocabulary at a time, determined by `rownames`: character
#' names for `"long"` and `"short"`, integer NCBI Taxonomy IDs for `"NCBI"`. A
#' `"long"` object therefore gives a clade-string to NCBI-name mapping on its own,
#' because its row names and its `rowData()` names are different vocabularies.
#' Getting the integer identifiers alongside the names takes a second call.
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
#' @importFrom stringr str_c str_replace
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom AnnotationHub query
#' @importFrom S4Vectors mcols
#' @importFrom ExperimentHub package
#' @importFrom magrittr extract
#' @importFrom tibble as_tibble
#' @importFrom tidyr separate
#' @importFrom rlang .data rep_named
#' @importFrom dplyr group_by
#' @importFrom dplyr slice_max
#' @importFrom dplyr ungroup
#' @importFrom magrittr set_names
#' @importFrom dplyr filter
#' @importFrom tibble column_to_rownames
#' @importFrom dplyr select
#' @importFrom S4Vectors DataFrame
#' @importFrom magrittr multiply_by
#' @importFrom magrittr divide_by
#' @importFrom S4Vectors SimpleList
#' @importFrom TreeSummarizedExperiment TreeSummarizedExperiment
#' @importFrom SummarizedExperiment rowData<-
#' @importFrom mia taxonomyRankEmpty getTaxonomyLabels agglomerateByVariable
#' @importFrom TreeSummarizedExperiment rownames<-
#' @importFrom SummarizedExperiment rowData
#' @importFrom SummarizedExperiment assay<-
#' @importFrom SummarizedExperiment assay<-
#' @importFrom SummarizedExperiment SummarizedExperiment
curatedMetagenomicData <- function(pattern, dryrun = TRUE, counts = FALSE, rownames = "long") {
    if (missing(pattern)) {
        stop("the pattern argument is missing", call. = FALSE)
    }

    resources <-
        str_subset(resourceTitles, pattern)

    if (length(resources) == 0) {
        stop("no resources available in curatedMetagenomicData", call. = FALSE)
    }

    if (dryrun) {
        str_c(resources, collapse = "\n") |>
            message()

        return(invisible(resources))
    }

    resources <-
        str_c(resources, collapse = "|")

    to_return <-
        ExperimentHub() |>
        query(resources)

    to_subset <-
        mcols(to_return)

    keep_rows <-
        package(to_return) %in% "curatedMetagenomicData"

    into_cols <-
        c("date_added", "study_name", "data_type")

    resources <-
        extract(to_subset, keep_rows, "title", drop = FALSE) |>
        as_tibble(rownames = "rowname") |>
        separate(.data[["title"]], into_cols, sep = "\\.", remove = FALSE) |>
        group_by(.data[["study_name"]], .data[["data_type"]]) |>
        slice_max(.data[["date_added"]]) |>
        ungroup()

    resource_list <-
        rep_named(resources[["title"]], list(NULL))

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

            tree_summarized_experiment <-
                TreeSummarizedExperiment(assays = assays, colData = colData, rowTree = phylogeneticTree)

            keep_ranks <-
                c("superkingdom", "phylum", "class", "order", "family", "genus", "species")

            if (rownames == "NCBI") {
                rowData(tree_summarized_experiment) <-
                    extract(rowDataNCBI, keep_tips, keep_ranks)
            } else {
                rowData(tree_summarized_experiment) <-
                    extract(rowDataLong, keep_tips, keep_ranks)
            }

            if (rownames != "long") {
                # taxonomyRankEmpty() defaults to the first rank, which here is
                # superkingdom and is never empty, so the rank has to be named.
                # Rows whose lineage stops above species cannot be given a
                # species-level label, and leaving them in makes
                # getTaxonomyLabels() prefix every label with its rank.
                wo_taxonomy <-
                    taxonomyRankEmpty(tree_summarized_experiment,
                                      rank = "species")

                if (any(wo_taxonomy)) {
                    drop_rows <-
                        rownames(tree_summarized_experiment)[wo_taxonomy]

                    warning(
                        "dropping ", sum(wo_taxonomy), " taxa from `",
                        resource_names[[i]], "` with no species-level name:\n",
                        str_c("  ", str_replace(drop_rows, "^.*\\|s__", ""),
                              collapse = "\n"),
                        "\nThese are MetaPhlAn species groups and complexes ",
                        "that NCBI does not resolve to a species. Use ",
                        "rownames = \"long\" to keep every taxon.",
                        call. = FALSE
                    )

                    tree_summarized_experiment <-
                        tree_summarized_experiment[!wo_taxonomy, ]
                }

                if (rownames == "NCBI") {
                    # NCBI has merged some species that MetaPhlAn still reports
                    # as separate clades, so one identifier can belong to two or
                    # three rows. Sum them: these are partitioned reads of one
                    # organism, not repeated measurements of it.
                    species_id <-
                        as.character(rowData(tree_summarized_experiment)[["species"]])

                    if (anyDuplicated(species_id)) {
                        merged_ids <-
                            base::unique(species_id[base::duplicated(species_id)])

                        clade_names <-
                            str_replace(rownames(tree_summarized_experiment),
                                        "^.*\\|s__", "")

                        merge_lines <-
                            vapply(merged_ids, function(id) {
                                members <- clade_names[species_id == id]
                                str_c("  ", id, " <- ",
                                      str_c(members, collapse = ", "))
                            }, character(1L))

                        message(
                            "\nmerging ", base::sum(species_id %in% merged_ids),
                            " rows of `", resource_names[[i]], "` into ",
                            base::length(merged_ids),
                            " NCBI Taxonomy IDs, summing their values:\n",
                            str_c(merge_lines, collapse = "\n"), "\n"
                        )

                        tree_summarized_experiment <-
                            agglomerateByVariable(tree_summarized_experiment,
                                                  by = "rows",
                                                  group = species_id,
                                                  update.tree = TRUE)
                    }
                }

                rownames(tree_summarized_experiment) <-
                    getTaxonomyLabels(tree_summarized_experiment)
            }

            resource_list[[i]] <-
                tree_summarized_experiment
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
