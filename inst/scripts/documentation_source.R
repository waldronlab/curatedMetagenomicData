documentation_source <- function(first_element, documentation_df) {
    documentation_df$source[first_element] %>%
    paste0("\n#' @source ", ., "\n#'")
}
