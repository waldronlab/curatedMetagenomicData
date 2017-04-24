documentation_source <- function(first_element, documentation_df) {
    subsection_name <- c("Title", "Author", "Lab", "PMID")
    subsection_text <- documentation_df[first_element, 4:7]
    bpmapply(subsection_str, subsection_name, subsection_text) %>%
        unlist() %>%
        as.character() %>%
        paste0(., collapse = "")
}
