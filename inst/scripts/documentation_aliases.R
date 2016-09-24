documentation_aliases <- function(title_str, documentation_df) {
    grep(title_str, documentation_df$title)

}
