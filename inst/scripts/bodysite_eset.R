bodysite_eset <- function(assay_data, pheno_data, dataset_dir, data_type) {
    merged_eset <- merged_eset(assay_data, pheno_data)
    unique(merged_eset$bodysite) %>%
    bplapply(., save_eset, dataset_dir, data_type, merged_eset)
}
