miame_other <- function(metadata) {
    select(metadata, sequencing_platform) %>%
    unique() %>%
    list("Sequencing platform" = .)
}
