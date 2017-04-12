documentation_eda <- function(first_element, documentation_df) {
    eda_vars <- c("bodysite", "disease", "age", "gender", "country", "bmi",
                  "height", "weight", "diabetic", "antibiotic_usage")

    subsection_name <- documentation_df$aliases[first_element]
    subsection_text <- documentation_df$subsection[first_element]
    bpmapply(subsection_str, subsection_name, subsection_text) %>%
        unlist() %>%
        as.character() %>%
        paste0(., collapse = "")

    paste0()
}
