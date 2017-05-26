assay_merge <- function(tsv_list) {
    lapply(tsv_list, read_assay) %>%
    Reduce(join_assays, .) %>%
    as.data.frame()
}
