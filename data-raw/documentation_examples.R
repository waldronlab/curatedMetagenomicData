documentation_examples <- function(first_element, documentation_df) {
    documentation_df$aliases[first_element] %>%
    gsub("genefamilies_relab", "metaphlan_bugs_list", .) %>% {
        ifelse(grepl("-", .), paste0("`", ., "`"), .)
    } %>%
    paste0("\n#' @examples ", ., "()\n#'")
}
