get_titles <- function(ResourceName) {
    lapply(ResourceName, strip_rda) %>%
    as.character()
}
