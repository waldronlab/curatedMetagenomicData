author_df <- function(pubmed_query) {
    Author(pubmed_query) %>%
    as.data.frame()
}
