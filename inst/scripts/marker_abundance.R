marker_abundance <- function(pheno_data, dataset_dir) {
    data_type <- "marker_abundance"
    paste0(dataset_dir, data_type) %>%
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames(., data_type) %>%
    bodysite_eset(., pheno_data, dataset_dir, data_type)
}
