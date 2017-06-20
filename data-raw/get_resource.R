get_resource <- function(resource_name) {
    resource_path <- paste0("./uploads/", resource_name)
    load(resource_path)
    gsub("^([0-9])+\\.", "", resource_name) %>%
    gsub(".rda", "", .) %>%
    get()
}
