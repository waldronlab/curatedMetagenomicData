pheno_data <- function(metadata) {
    select(metadata, -pubmedid, -sequencing_technology) %>%
    as.data.frame() %>%
    fix_rownames() %>%
    AnnotatedDataFrame()
}
