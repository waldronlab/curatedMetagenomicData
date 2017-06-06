pubmed_query <- function(metadata) {
    select(metadata, PMID) %>%
    unlist() %>%
    as.integer() %>%
    unique() %>%
    pubmed_check() %>%
    EUtilsGet()
}
