is_rda <- function() {
    dir("./data") %>%
    basename() %>%
    lapply(., grepl_rda) %>%
    as.logical()
}
