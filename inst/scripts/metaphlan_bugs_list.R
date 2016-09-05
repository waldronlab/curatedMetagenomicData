metaphlan_bugs_list <- function(pheno_data, dataset_dir) {
    data_type <- "metaphlan_bugs_list"
    paste0(dataset_dir, data_type) %>%
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames(., data_type) %>%
    bodysite_eset(., pheno_data, dataset_dir, data_type)
}
