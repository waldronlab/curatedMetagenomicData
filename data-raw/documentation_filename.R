documentation_filename <- function(first_element, documentation_df) {
    documentation_df$name[first_element] %>%
    paste0("./R/", ., ".R")
}
