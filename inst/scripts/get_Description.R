get_Description <- function(resource_name) {
    strsplit(resource_name, "\\.") %>%
    unlist() %>%
    description_str()
}
