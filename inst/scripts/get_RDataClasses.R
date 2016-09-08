get_RDataClasses <- function() {
    dir("./data") %>%
    basename() %>%
    lapply(., strip_rda) %>%
    as.character()
}
