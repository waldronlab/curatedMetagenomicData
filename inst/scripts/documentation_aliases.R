documentation_aliases <- function(every_element, documentation_df) {
    documentation_df$aliases[every_element] %>%
    paste0(., collapse = " ") %>%
    paste("\n#' @aliases", ., "\n#'")
}
