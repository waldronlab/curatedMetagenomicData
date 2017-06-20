pheno_order <- function(pheno_data, dataset_dir, data_type) {
    rownames_match <- rownames_match(pheno_data, dataset_dir, data_type)
    if(rownames_match) {
        rownames(pheno_data) %>%
        paste0(dataset_dir, data_type, "/", ., ".tsv") %>%
        as.list()
    }
}
