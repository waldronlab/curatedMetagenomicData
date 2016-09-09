get_class <- function(rda_file) {
    load(rda_file)
    basename(rda_file) %>%
    strip_rda() %>%
    get() %>%
    class() %>%
    as.character()
}
