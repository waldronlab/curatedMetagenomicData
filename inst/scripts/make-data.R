library(dplyr)

read.dcf("DESCRIPTION", "Suggests") %>%
    gsub("\n", "", .) %>%
    strsplit(",") %>%
    unlist() %>%
    for (i in .) {
        if(!require(i, character.only = TRUE)) {
            BiocManager::install(i)
            require(i, character.only = TRUE)
        }
    }

dir("./data-raw/") %>%
    paste0("./data-raw/", .) %>%
    lapply(source) %>%
    invisible()

readLines("./inst/extdata/curatedMetagenomicData.txt") %>%
    paste0(collapse = "\n") %>%
    message()

message("Use make_data() or make_all() to process a metagenomic dataset")
message("See documentation at tinyurl.com/Adding-New-Data for more info")
