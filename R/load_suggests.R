#' @importFrom utils install.packages
#' @keywords internal
load_suggests <- function() {
    read.dcf("DESCRIPTION", "Suggests") %>%
    gsub("\n", "", .) %>%
    strsplit(., ",") %>%
    unlist() %>%
    for (i in .) {
        if(!require(i, character.only = TRUE)) {
            install.packages(i)
            require(i, character.only = TRUE)
        }
    }
}
