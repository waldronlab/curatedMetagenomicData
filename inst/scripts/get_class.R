get_class <- function(rda_file) {
    load(rda_file) %>%
    class()
}
