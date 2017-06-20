miame_name <- function(pubmed_query) {
    author_df <- author_df(pubmed_query)
    mapply(author_str, author_df$Initials, author_df$LastName) %>%
    paste(., collapse = ", ")
}
