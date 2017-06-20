make_data_documentation <- function() {
    dir("./uploads") %>%
    lapply(., get_documentation) %>%
    parallel_rbind() %>%
    write_documentation()
    invisible(NULL)
}
