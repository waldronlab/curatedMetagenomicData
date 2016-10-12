pubmed_query <- function(metadata) {
    select(metadata, pubmedid) %>%
    unique() %>%
    pubmed_check() %>%
    EUtilsGet()
}

