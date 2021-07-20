phylogenetic_tree_file <-
    base::as.character("https://raw.githubusercontent.com/biobakery/MetaPhlAn/master/metaphlan/utils/mpa_v30_CHOCOPhlAn_201901_species_tree.nwk")

phylogenetic_tree_path <-
    base::tempfile()

utils::download.file(url = phylogenetic_tree_file, destfile = phylogenetic_tree_path)

phylogeneticTree <-
    ape::read.tree(phylogenetic_tree_path)

phylogeneticTree[["tip.label"]] <-
    stringr::str_remove_all(phylogeneticTree[["tip.label"]], "GCA_[0-9]+\\|")

col_types <-
    readr::cols(
        Title = readr::col_character(),
        .default = readr::col_skip()
    )

into_cols <-
    base::c("date_added", "study_name", "data_type")

title <-
    readr::read_csv("inst/extdata/metadata.csv", col_types = col_types) |>
    tidyr::separate(Title, into_cols, sep = "\\.", remove = FALSE) |>
    dplyr::arrange(study_name, date_added, data_type) |>
    dplyr::pull(.data[["Title"]])

usethis::use_data(phylogeneticTree, title, internal = TRUE, overwrite = TRUE)
