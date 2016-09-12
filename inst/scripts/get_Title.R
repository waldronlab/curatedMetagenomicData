get_Title <- function(resource_name) {
    lapply(resource_name, strip_rda) %>%
    as.character()
}
