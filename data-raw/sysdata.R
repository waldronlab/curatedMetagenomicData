phylogenetic_tree_file <-
    base::as.character("https://raw.githubusercontent.com/biobakery/MetaPhlAn/master/metaphlan/utils/mpa_v30_CHOCOPhlAn_201901_species_tree.nwk")

phylogenetic_tree_path <-
    base::tempfile()

utils::download.file(url = phylogenetic_tree_file, destfile = phylogenetic_tree_path)

phylogeneticTree <-
    ape::read.tree(phylogenetic_tree_path)

phylogeneticTree[["tip.label"]] <-
    stringr::str_remove_all(phylogeneticTree[["tip.label"]], "GCA_[0-9]+\\|")

ranks <-
    base::c("superkingdom", "phylum", "class", "order", "family", "genus", "species")

taxonomyData <-
    stringr::str_remove_all(phylogeneticTree[["tip.label"]], ".+__") |>
    stringr::str_replace_all("_", " ") |>
    taxize::get_uid(ask = FALSE, messages = FALSE) |>
    taxize::classification(return_id = FALSE) |>
    purrr::map_if(base::is.logical, ~ data.frame(name = NA_character_, rank = ranks)) |>
    purrr::map(~ dplyr::filter(.x, rank %in% ranks)) |>
    purrr::map(~ tidyr::pivot_wider(.x, names_from = "rank", values_from = "name")) |>
    purrr::imap_dfr(~ dplyr::mutate(.x, txid = .y)) |>
    dplyr::mutate(rowname = phylogeneticTree[["tip.label"]]) |>
    dplyr::mutate(txid = dplyr::if_else(base::is.na(species), NA_character_, txid)) |>
    dplyr::mutate(superkingdom = dplyr::if_else(base::is.na(species), NA_character_, superkingdom)) |>
    dplyr::mutate(phylum = dplyr::if_else(base::is.na(species), NA_character_, phylum)) |>
    dplyr::mutate(class = dplyr::if_else(base::is.na(species), NA_character_, class)) |>
    dplyr::mutate(order = dplyr::if_else(base::is.na(species), NA_character_, order)) |>
    dplyr::mutate(family = dplyr::if_else(base::is.na(species), NA_character_, family)) |>
    dplyr::mutate(genus = dplyr::if_else(base::is.na(species), NA_character_, genus)) |>
    dplyr::mutate(species = dplyr::if_else(base::is.na(species), NA_character_, species)) |>
    dplyr::select(rowname, txid, tidyselect::all_of(ranks))

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

usethis::use_data(phylogeneticTree, taxonomyData, title, internal = TRUE, overwrite = TRUE)
