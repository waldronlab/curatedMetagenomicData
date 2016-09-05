genefamilies_relab <- function(pheno_data, dataset_dir) {
    data_type <- "genefamilies_relab"
    paste0(dataset_dir, data_type) %>%
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames(., data_type) %>%
    drop_rows() %>%
    bodysite_eset(., pheno_data, dataset_dir, data_type)
}
