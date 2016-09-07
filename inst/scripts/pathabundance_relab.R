pathabundance_relab <- function(pheno_data, dataset_dir) {
    data_type <- "pathabundance_relab"
    pheno_order(pheno_data, dataset_dir, data_type) %>%
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames(., data_type) %>%
    na_zero() %>%
    bodysite_eset(., pheno_data, dataset_dir, data_type)
}
