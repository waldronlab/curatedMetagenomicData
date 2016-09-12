miame_lab <- function(pubmed_query) {
    Affiliation(pubmed_query) %>%
    paste(., collapse = ", ")
}
