library(magrittr)

installed_packages <-
    utils::installed.packages() %>%
    base::rownames()

if (!("purrr" %in% installed_packages)) {
    BiocManager::install("purrr")
}

BiocManager::install("waldronlab/curatedMetagenomicDataCuration")

col_types <-
    readr::cols(
        family = readr::col_character(),
        PMID = readr::col_character()
    )

base::load("R/sysdata.rda")

validName <-
    stringr::str_extract(Title, "[A-Z].+") %>%
    stringr::str_remove("\\..+") %>%
    base::unique()

combined_metadata <-
    base::system.file("curated", package = "curatedMetagenomicDataCuration") %>%
    base::dir(pattern = "tsv", full.names = TRUE, recursive = TRUE) %>%
    purrr::set_names(nm = ~ base::basename(.x)) %>%
    purrr::set_names(nm = ~ stringr::str_remove(.x, "_metadata.tsv")) %>%
    purrr::map(~ readr::read_tsv(.x, col_types = col_types)) %>%
    purrr::imap(~ dplyr::mutate(.x, dataset_name = .y, .before = "sampleID")) %>%
    purrr::reduce(dplyr::bind_rows) %>%
    dplyr::filter(dataset_name %in% validName) %>%
    base::as.data.frame()

usethis::use_data(combined_metadata, overwrite = TRUE)
