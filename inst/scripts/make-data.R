if (!require("magrittr", character.only = TRUE)) {
    BiocManager::install("magrittr")
    require("magrittr", character.only = TRUE)
}

base::read.dcf("DESCRIPTION", "Suggests") %>%
    base::gsub("\n", "", x = .) %>%
    base::strsplit(",") %>%
    base::unlist() %>%
    for (i in .) {
        if (!require(i, character.only = TRUE)) {
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
