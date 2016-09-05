merged_eset <- function(assay_data, pheno_data) {
    as.matrix(assay_data) %>%
    ExpressionSet(., pheno_data)
}
