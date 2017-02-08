rownames_match <- function(pheno_data, dataset_dir, data_type) {
    pheno_rownames <- rownames(pheno_data)
    paste0(dataset_dir, data_type) %>%
    dir() %>%
    gsub(".tsv", "", .) %>%
    is.element(., pheno_rownames) %>%
    all()
}
