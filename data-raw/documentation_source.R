documentation_source <- function(first_element, documentation_df) {
    subsection_name <- c("Title", "Author", "Lab", "PMID")
    subsection_text <- documentation_df[first_element, 4:7]
    ifelse(nchar(subsection_text) > 1, subsection_text, "NA") %>%
    bpmapply(subsection_str, subsection_name, .) %>%
        unlist() %>%
        as.character() %>%
        paste0(., collapse = "")
}
