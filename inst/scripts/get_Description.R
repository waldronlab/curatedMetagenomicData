get_Description <- function(resource_name) {
    strsplit(resource_name, "\\.") %>%
    as.character() %>%
    description_str()
}
