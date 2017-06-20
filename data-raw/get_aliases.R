get_aliases <- function(resource_name) {
    gsub("^([0-9])+\\.", "", resource_name) %>%
        gsub(".rda", "", .)
}
