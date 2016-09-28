pubmed_query <- function(metadata) {
    select(metadata, pubmedid) %>%
    unique() %>%
    EUtilsGet()
}
