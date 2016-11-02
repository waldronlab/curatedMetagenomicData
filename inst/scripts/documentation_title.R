documentation_title <- function(first_element, documentation_df) {
    documentation_df$title[first_element] %>%
    paste0("\n#' ", ., "\n#'")
}
