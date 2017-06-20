bodysite_eset <- function(assay_data, pheno_data, experiment_data, dataset_dir,
                          data_type) {
    merged_eset <- merged_eset(assay_data, pheno_data, experiment_data)
    unique(merged_eset$body_site) %>%
    lapply(., save_eset, dataset_dir, data_type, merged_eset)
}
