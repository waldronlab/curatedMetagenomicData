get_technology <- function(resource_object) {
    experimentData(resource_object)@other %>%
        unlist() %>%
        as.character()
}
