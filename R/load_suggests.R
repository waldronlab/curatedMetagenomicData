#' @importFrom magrittr %>%
#' @importFrom BiocInstaller biocLite
#' @keywords internal
load_suggests <- function() {
    read.dcf("DESCRIPTION", "Suggests") %>%
    gsub("\n", "", .) %>%
    strsplit(., ",") %>%
    unlist() %>%
    for (i in .) {
        if(!require(i, character.only = TRUE)) {
            biocLite(i)
            require(i, character.only = TRUE)
        }
    }
}
