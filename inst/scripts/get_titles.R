get_titles <- function(){
    dir("./data") %>%
    basename() %>%
    lapply(., strip_rda) %>%
    as.character()
}
