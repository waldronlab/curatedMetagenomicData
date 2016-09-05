assay_merge <- function(dir_name) {
    paste0(dir_name, "/", dir(dir_name)) %>%
    lapply(., read_data) %>%
    Reduce(join_data, .) %>%
    as.data.frame()
}
