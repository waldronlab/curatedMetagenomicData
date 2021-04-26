
metaphlan_tree_file <- base::tempfile()
metaphlan_tree_url <- "https://raw.githubusercontent.com/biobakery/MetaPhlAn/master/metaphlan/utils/mpa_v30_CHOCOPhlAn_201901_species_tree.nwk"
utils::download.file(url = metaphlan_tree_url, destfile = metaphlan_tree_file)
phylogeneticTree <- ape::read.tree(metaphlan_tree_file)
phylogeneticTree$tip.label <- base::sub("\\|GCF_[0-9]+$", "", phylogeneticTree$tip.label)
phylogeneticTree$tip.label <- base::gsub(".+\\|", "", phylogeneticTree$tip.label)
usethis::use_data(phylogeneticTree)

