miame_other <- function(metadata) {
    select(metadata, sequencing_technology) %>%
    unique() %>%
    as.character() %>%
    list("Sequencing technology" = .)
}
