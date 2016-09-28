miame_other <- function(metadata) {
    select(metadata, sequencing_technology) %>%
    unique() %>%
    list("Sequencing technology" = .)
}
