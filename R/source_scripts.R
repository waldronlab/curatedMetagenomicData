#' @keywords internal

source_scripts <- function() {
    dir("./inst/scripts") %>%
    paste0("./inst/scripts/", .) %>%
    lapply(., source)
    NULL
}
