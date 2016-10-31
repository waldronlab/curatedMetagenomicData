miame_lab <- function(pubmed_query) {
    Affiliation(pubmed_query) %>%
    gsub("1\\]", "\\[1\\]", .) %>%
    iconv(., to = "ASCII//TRANSLIT") %>%
    paste(., collapse = ", ")
}
