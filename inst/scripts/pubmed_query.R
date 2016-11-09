pubmed_query <- function(metadata) {
    select(metadata, pubmedid) %>%
    unlist() %>%
    as.integer() %>%
    unique() %>%
    pubmed_check() %>%
    EUtilsGet()
}
