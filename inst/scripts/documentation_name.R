documentation_name <- function(first_element, documentation_df) {
    documentation_df$name[first_element] %>%
    paste0("\n#' @name ", .)
}
