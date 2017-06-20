format_pheno_data <- function(metadata) {
    select(metadata, -PMID, -sequencing_platform) %>%
    as.data.frame() %>%
    fix_rownames() %>%
    AnnotatedDataFrame()
}
