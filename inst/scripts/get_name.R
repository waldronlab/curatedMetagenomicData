get_name <- function(resource_name) {
    strsplit(resource_name, "\\.") %>%
    unlist() %>%
    name_str()
}
