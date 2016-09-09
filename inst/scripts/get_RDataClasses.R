get_RDataClasses <- function(ResourceName) {
    paste0("./data/", ResourceName) %>%
    lapply(., get_class) %>%
    as.character()
}
