#' Convert an ExpressionSet object to a metagenomeSeq::MRexperiment-class object
#'
#' @param eset
#'
#' An eset object
#'
#' @param simplify
#'
#' if TRUE the most detailed clade name is used, instead of the original 
#' metaPhlAn2 names which contain the full taxonomy.
#'
#' @return
#'
#' A metagenomeSeq::MRexperiment-class object
#'
#' @export
#'
#' @examples
#' eset <- LomanNJ_2013_Mi.metaphlan_bugs_list.stool()
#' ExpressionSet2MRexperiment(eset)
#'
#' @importFrom Biobase exprs
#' @importFrom Biobase pData
#' @importFrom magrittr %>%
#' @importFrom dplyr data_frame
#' @importFrom tidyr separate
ExpressionSet2MRexperiment <- function(eset, simplify = TRUE){
  library(magrittr)
  library(tidyr)
  library(metagenomeSeq)
  taxonomic.ranks <- c("Kingdom", "Phylum", "Class", "Order", "Family",
                       "Genus", "Species", "Strain")
  otu.table <- exprs(eset)
  if(max(otu.table) < 101) {
    otu.table <- round(sweep(otu.table, 2, eset$number_reads/100, "*"))
  }
  tax.table <- rownames(otu.table) %>%
    gsub("[a-z]__", "", .) %>%
    data_frame() %>%
    separate(., ".", taxonomic.ranks, sep = "\\|", fill="right") %>%
    as.matrix()
  if(simplify) {
    rownames(otu.table) <- rownames(otu.table) %>%
      gsub(".+\\|", "", .)
  }
  rownames(tax.table) <- rownames(otu.table)
  tax.table <- AnnotatedDataFrame(data.frame(tax.table))
  mgseq = newMRexperiment(counts = otu.table,
                          phenoData = phenoData(eset),
                          featureData = tax.table)
  return(mgseq)
}
