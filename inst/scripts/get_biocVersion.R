get_biocVersion <- function(ResourceName_length) {
    biocVersion() %>%
    as.character() %>%
    rep(., ResourceName_length)
}
