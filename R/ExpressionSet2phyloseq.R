#' Convert an ExpressionSet object to a phyloseq object
#'
#' @param eset
#'
#' An eset object
#'
#' @param simplify
#'
#' if TRUE the most detailed clade name is used
#'
#' @param relab
#'
#' if FALSE, values are multiplied by read depth to approximate counts, if TRUE
#' (default) values kept as relative abundances between 0 and 100\%.
#'
#' @return
#'
#' A phyloseq object
#'
#' @export
#'
#' @examples
#' LomanNJ_2013.metaphlan_bugs_list.stool() %>%
#' ExpressionSet2phyloseq()
#'
#' @importFrom Biobase exprs
#' @importFrom Biobase pData
#' @importFrom magrittr %>%
#' @importFrom dplyr data_frame
#' @importFrom tidyr separate
ExpressionSet2phyloseq <- function(eset, simplify = TRUE,
                                   relab = TRUE) {

    if (!requireNamespace("phyloseq"))
        stop("Please install the 'phyloseq' package to make phyloseq objects")

    otu.table <- exprs(eset)
    sample.data <- pData(eset) %>%
        phyloseq::sample_data(., errorIfNULL = FALSE)

    taxonomic.ranks <- c("Kingdom", "Phylum", "Class", "Order", "Family",
                         "Genus", "Species", "Strain")
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
    if(!relab) {
        otu.table <- round(sweep(otu.table, 2, eset$number_reads/100, "*"))
    }
    otu.table <- phyloseq::otu_table(otu.table, taxa_are_rows = TRUE)
    tax.table <- phyloseq::tax_table(tax.table)
    phyloseq::phyloseq(otu.table, sample.data, tax.table)
}
