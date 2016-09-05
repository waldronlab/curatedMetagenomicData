assay_merge <- function(assay_dir) {
    dir(assay_dir) %>%
    paste0(assay_dir, "/", .) %>%
    lapply(., read_assay) %>%
    Reduce(join_assays, .) %>%
    as.data.frame()
}
