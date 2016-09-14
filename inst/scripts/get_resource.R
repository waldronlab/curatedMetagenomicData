get_resource <- function(resource_name) {
    resource_path <- paste0("./data/", resource_name)
    load(resource_path)
    gsub(".rda", "", resource_name) %>%
    get()
}
