get_biocVersion <- function(ResourceName_length) {
    biocVersion() %>%
    rep(., ResourceName_length)
}
