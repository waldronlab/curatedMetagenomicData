bodysite_eset <- function(assay_data, pheno_data, dataset_dir, data_type) {
    as.matrix(assay_data) %>%
    ExpressionSet(., pheno_data) %>%
    lapply(unique(.$bodysite), function(x, y) {
        eset_name <- paste(basename(dataset_dir), data_type, x, sep = ".")
        assign(eset_name, y[, y$bodysite == x])
        save(list = eset_name, file = paste0("./data/", eset_name, ".rda"))
    }, y = .)
}
