bodysite_eset <- function(assay_data) {
    as.matrix(assay_data) %>%
    ExpressionSet(., pheno_data) %>%
    lapply(unique(.$bodysite), function(x, y) {
        y[, y$bodysite == x]
        paste(basename(getwd()), basename(dir_name), x, "rda", sep = ".") %>%
        save(y, file = .)
    }, y = .)
}
