write_documentation <- function(documentation_df) {
    unique(documentation_df$title) %>%
    bplapply(., cat_documentation, documentation_df)
}
