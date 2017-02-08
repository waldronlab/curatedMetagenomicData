read.dcf("DESCRIPTION", "Suggests") %>%
    gsub("\n", "", .) %>%
    strsplit(",") %>%
    unlist() %>%
    for (i in .) {
        if(!require(i, character.only = TRUE)) {
            biocLite(i)
            require(i, character.only = TRUE)
        }
    }

dir("./data-raw/") %>%
    paste0("./data-raw/", .) %>%
    lapply(source) %>%
    invisible()
