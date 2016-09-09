is_rda <- function(ResourceName) {
    lapply(ResourceName, grepl_rda) %>%
    as.logical()
}
