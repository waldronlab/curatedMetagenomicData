get_resource <- function(resource_name) {
    paste0("./data/", resource_name) %>%
    load()
    gsub(".rda", "", resource_name) %>%
    get()
}
