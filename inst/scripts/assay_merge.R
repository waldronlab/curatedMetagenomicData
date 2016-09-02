assay_merge <- function() {
    paste0(dir_name, "/", dir(dir_name)) %>%
    lapply(., read_tsv) %>%
    Reduce(full_join, .) %>%
    as.data.frame()
}
