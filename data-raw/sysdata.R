library(magrittr)

installed_packages <-
    utils::installed.packages() %>%
    base::rownames()

if (!("BiocManager" %in% installed_packages)) {
    utils::install.packages("BiocManager")
}

if (!("readr" %in% installed_packages)) {
    BiocManager::install("readr")
}

if (!("usethis" %in% installed_packages)) {
    BiocManager::install("usethis")
}

col_types <-
    readr::cols(
        Title = readr::col_character(),
        .default = readr::col_skip()
    )

into_cols <-
    base::c("dateAdded", "studyName", "dataType")

Title <-
    readr::read_csv("inst/extdata/metadata.csv", col_types = col_types) %>%
    tidyr::separate(Title, into_cols, sep = "\\.", remove = FALSE) %>%
    dplyr::arrange(studyName, dateAdded, dataType) %>%
    dplyr::pull(.data[["Title"]])

usethis::use_data(Title, internal = TRUE, overwrite = TRUE)
