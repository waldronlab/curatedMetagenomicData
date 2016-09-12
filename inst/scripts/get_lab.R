get_lab <- function(rda_file) {
    load(rda_file)
    basename(rda_file) %>%
    strip_rda() %>%
    experimentData(.)@lab %>%
    as.character()
}
