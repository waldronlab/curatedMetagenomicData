write_documentation <- function(documentation_df) {
    unique(documentation_df$title) %>%
    lapply(., cat_documentation, documentation_df)
}
