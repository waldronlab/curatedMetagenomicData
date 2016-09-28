make_documentation <- function() {
    dir("./data") %>%
    bplapply(., get_documentation) %>%
    Reduce(bind_rows, .) %>%
    write_documentation()
    invisible(NULL)
}
