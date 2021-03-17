BiocManager::install("waldronlab/curatedMetagenomicDataCuration")

library(magrittr)

col_types <-
    readr::cols(
        family = readr::col_character(),
        PMID = readr::col_character()
    )

metadata <-
    base::system.file("curated", package = "curatedMetagenomicDataCuration") %>%
    base::dir(pattern = "tsv", full.names = TRUE, recursive = TRUE) %>%
    purrr::set_names(nm = ~ base::basename(.x)) %>%
    purrr::set_names(nm = ~ stringr::str_remove(.x, "_metadata.tsv")) %>%
    purrr::map(~ readr::read_tsv(.x, col_types = col_types)) %>%
    purrr::imap(~ dplyr::mutate(.x, studyName = .y, .before = "sampleID")) %>%
    purrr::reduce(dplyr::bind_rows) %>%
    base::as.data.frame()

usethis::use_data(metadata, overwrite = TRUE)
