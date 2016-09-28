documentation_seealso <- function(every_element, documentation_df) {
    documentation_df$seealso[every_element] %>%
    unique() %>%
    grep(., documentation_df$seealso) %>%
    setdiff(., every_element) %>%
    documentation_df$name[.] %>%
    paste0("\\code{\\link{", ., "}}") %>%
    paste(., collapse = ", ") %>%
    paste0("\n#' @seealso ", ., "\n#'")
}
