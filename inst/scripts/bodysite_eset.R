bodysite_eset <- function(assay_data) {
    as.matrix(assay_data) %>%
    ExpressionSet(., pheno_data) %>%
    lapply(unique(.$bodysite), function(x, y) {
        eset_name <- paste(basename(getwd()), basename(dir_name), x, sep = ".")
        y[, y$bodysite == x] %>%
        assign(eset_name, .)
        save(get(eset_name), file = paste(eset_name, "rda", sep = "."))
    }, y = .)
}
