get_documentation <- function(resource_name) {
    resource_object <- get_resource(resource_name)
    title <- get_title(resource_name)
    aliases <- gsub(".rda", "", resource_name)
    subsection <- get_subsection(resource_object)
    source <- experimentData(resource_object)@lab
    name <- get_name(resource_name)
    seealso <- strsplit(resource_name, "\\.")[[1]][1]
    data_frame(title, aliases, subsection, source, name, seealso)
}
