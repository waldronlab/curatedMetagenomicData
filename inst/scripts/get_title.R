get_title <- function(resource_name) {
    strsplit(resource_name, "\\.") %>%
    unlist() %>%
    title_str()
}
