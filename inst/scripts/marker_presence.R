marker_presence <- function(pheno_data, experiment_data, dataset_dir) {
    data_type <- "marker_presence"
    pheno_order(pheno_data, dataset_dir, data_type) %>%
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames(., data_type) %>%
    na_zero() %>%
    bodysite_eset(., pheno_data, experiment_data, dataset_dir, data_type)
}
