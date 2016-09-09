get_Maintainer <- function(ResourceName_length) {
    read.dcf("DESCRIPTION", "Maintainer") %>%
    rep(., ResourceName_length)
}
