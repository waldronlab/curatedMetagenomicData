get_documentation <- function(resource_name) {
    resource_object <- get_resource(resource_name)
    title <- get_title(resource_name)
    aliases <- gsub(".rda", "", resource_name)
    subsection <- get_subsection(resource_object)
    publication <- get_experiment_data(resource_object, "title") %>% paste0(collapse = "; ")
    authors <- get_experiment_data(resource_object, "name")
    affiliations <- get_experiment_data(resource_object, "lab")
    pmid <- get_experiment_data(resource_object, "pubMedIds") %>% paste0(collapse = "; ")
    technology <- get_technology(resource_object)
    name <- get_name(resource_name)
    seealso <- strsplit(resource_name, "\\.")[[1]][2]
    data_frame(title, aliases, subsection, publication, authors, affiliations,
               pmid, technology, name, seealso)
}
