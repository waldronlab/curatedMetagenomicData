assay_merge <- function(tsv_list) {
    bplapply(tsv_list, read_assay) %>%
    parallel_join() %>%
    as.data.frame()
}
