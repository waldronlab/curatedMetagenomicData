phylogenetic_tree_file <-
    base::as.character("https://raw.githubusercontent.com/biobakery/MetaPhlAn/master/metaphlan/utils/mpa_v30_CHOCOPhlAn_201901_species_tree.nwk")

phylogenetic_tree_path <-
    base::tempfile()

utils::download.file(url = phylogenetic_tree_file, destfile = phylogenetic_tree_path)

phylogeneticTree <-
    ape::read.tree(phylogenetic_tree_path)

phylogeneticTree[["tip.label"]] <-
    stringr::str_remove_all(phylogeneticTree[["tip.label"]], "GCA_[0-9]+\\|")