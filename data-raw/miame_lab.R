miame_lab <- function(pubmed_query) {
    Affiliation(pubmed_query) %>%
        unlist() %>%
        unique() %>%
        iconv(., to = "ASCII//TRANSLIT") %>% {
            i <- 0
            j <- .
            for(k in j) {
                i <- i + 1
                j[i] <- paste0("[", i, "] ", k)
            }
            paste(j, collapse = ", ")
        }
}
