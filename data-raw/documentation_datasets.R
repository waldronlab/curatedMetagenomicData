documentation_datasets <- function(every_element, documentation_df) {
    subsection_name <- documentation_df$aliases[every_element]
    subsection_text <- documentation_df$subsection[every_element]
    bpmapply(subsection_str, subsection_name, subsection_text) %>%
    unlist() %>%
    as.character() %>%
    paste0(., collapse = "")
}
