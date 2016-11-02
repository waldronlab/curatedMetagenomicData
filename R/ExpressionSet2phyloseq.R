#' Convert an ExpressionSet object to a phyloseq object
#'
#' @param ExpressionSet
#'
#' An ExpressionSet object
#'
#' @param simplify
#'
#' if TRUE the most detailed clade name is used
#'
#' @param rounding
#'
#'  if TRUE values are rounded to the nearest interger
#'
#' @return
#'
#' A phyloseq object
#'
#' @export
#'
#' @examples
#' LomanNJ_2013_Mi.metaphlan_bugs_list.stool() %>%
#' ExpressionSet2phyloseq()
#'
#' @importFrom dplyr data_frame
#' @importFrom tidyr separate
ExpressionSet2phyloseq <- function(ExpressionSet, simplify = TRUE,
                                   rounding = TRUE) {
    otu_table <- exprs(ExpressionSet)
    sample_data <- pData(ExpressionSet) %>%
        sample_data(., errorIfNULL = FALSE)

    taxonomic_ranks <- c("Kingdom", "Phylum", "Class", "Order", "Family",
                         "Genus", "Species", "Strain")
    tax_table <- rownames(otu_table) %>%
        gsub("[a-z]__", "", .) %>%
        data_frame() %>%
        separate(., ".", taxonomic_ranks, sep = "\\|") %>%
        as.matrix()
    if(simplify == TRUE) {
        rownames(otu_table) <- rownames(otu_table) %>%
            gsub(".+\\|", "", .)
    }
    rownames(tax_table) <- rownames(otu_table)
    if(rounding == TRUE) {
        otu_table <- round(otu_table * 10000, 0)
    }
    otu_table <- otu_table(otu_table, taxa_are_rows = TRUE)
    tax_table <- tax_table(tax_table)
    phyloseq(otu_table, sample_data, tax_table)
}
