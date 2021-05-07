BiocManager::install("waldronlab/curatedMetagenomicDataCuration")

col_types <-
    readr::cols(
        col.name = readr::col_character(),
        col.class = readr::col_character(),
        uniqueness = readr::col_character(),
        requiredness = readr::col_character(),
        multiplevalues = readr::col_logical(),
        allowedvalues = readr::col_character(),
        description = readr::col_character()
    )

glue_str <-
    base::system.file("extdata", "template.csv", package = "curatedMetagenomicDataCuration") %>%
    readr::read_csv(col_types = col_types) %>%
    glue::glue_data('{col.name} = readr::col_{col.class}()') %>%
    glue::glue_collapse(sep = ", ")

cols_str <-
    glue::glue('readr::cols({glue_str})')

col_types <-
    base::parse(text = cols_str) %>%
    base::eval()

base::load("R/sysdata.rda")

valid_name <-
    stringr::str_extract(title, "[A-Z].+") %>%
    stringr::str_remove("\\..+") %>%
    base::unique()

sampleMetadata <-
    base::system.file("curated", package = "curatedMetagenomicDataCuration") %>%
    base::dir(pattern = "tsv", full.names = TRUE, recursive = TRUE) %>%
    purrr::set_names(nm = ~ base::basename(.x)) %>%
    purrr::set_names(nm = ~ stringr::str_remove(.x, "_metadata.tsv")) %>%
    purrr::map(~ readr::read_tsv(.x, col_types = col_types)) %>%
    purrr::imap(~ dplyr::mutate(.x, study_name = .y, .before = "sample_id")) %>%
    purrr::reduce(dplyr::bind_rows) %>%
    dplyr::filter(study_name %in% valid_name) %>%
    base::as.data.frame()

usethis::use_data(sampleMetadata, overwrite = TRUE)
