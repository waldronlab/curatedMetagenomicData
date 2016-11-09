documentation_examples <- function(first_element, documentation_df) {
  documentation_df$aliases[first_element] %>%
  paste0("\n#' @examples ", ., "()\n#'")
}
