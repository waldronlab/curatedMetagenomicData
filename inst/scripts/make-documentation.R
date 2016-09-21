make_documentation <- function() {
    dir("./data") %>%
    bplapply(., get_documentation) %>%
    parallel_rbind() %>%
    write_documentation()
}
