#' Title Return a phylogenetic tree for MetaPhlAn2 bugs
#'
#' @param simplify
#' if TRUE, only the most detailed level of the taxonomy is kept in the names,
#' for example species or strain.  Default is TRUE.
#' @param removeGCF
#' remove "|GCF_nnnnnnnnn" from the end of tip labels. Default is TRUE.
#' @return a phylogenetic tree of class ape::phylo
#' @export getMetaphlanTree
#' @details
#' The phylogenetic tree was built with PhyloPhlAn, using all the genomes
#' from MetaPhlAn2. Clades that had more than one leaf per species were
#' cleaned and a new tree generated with these selected genomes.
#' Labels are in the form: "taxonomy|genome_ID".
#' The Newick file of the tree is stored in the package as
#' inst/extdata/metaphlan2_selected.tree.reroot.nwk.bz2.
#' Thanks to Francesco Asnicar <f.asnicar@unitn.it> for generating this tree.
#' @examples
#' tree <- getMetaphlanTree()
#' summary(tree)
#' getMetaphlanTree(simplify = FALSE)
#' getMetaphlanTree(simplify = FALSE, removeGCF = FALSE)
#'
getMetaphlanTree <- function(removeGCF=TRUE, simplify=TRUE){
    if (!requireNamespace("ape")) {
        stop("Please install the ape package to read Newick trees")
    }
    nwkfile <- bzfile(system.file("extdata/metaphlan2_selected.tree.reroot.nwk.bz2",
                        package="curatedMetagenomicData"))
    tree <- ape::read.tree(nwkfile)
    close(nwkfile)
    if(removeGCF)
        tree$tip.label <- sub("\\|GCF_[0-9]+$", "", tree$tip.label)
    if(simplify)
        tree$tip.label <- gsub(".+\\|", "", tree$tip.label)
    return(tree)
}
