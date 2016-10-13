pubmed_check <- function(pubmedid) {
    if(length(pubmedid) >= 2) {
        warning("Multiple pubmedids were found but only the first will be used")
        pubmedid <- pubmedid[1]
    }
    if(is.na(pubmedid)) {
        pubmedid <- NULL
    }
    pubmedid
}
