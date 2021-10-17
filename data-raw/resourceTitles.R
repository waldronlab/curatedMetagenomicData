col_types <-
    readr::cols(
        Title = readr::col_character(),
        .default = readr::col_skip()
    )

into_cols <-
    base::c("date_added", "study_name", "data_type")

resourceTitles <-
    readr::read_csv("inst/extdata/metadata.csv", col_types = col_types) |>
    tidyr::separate(Title, into_cols, sep = "\\.", remove = FALSE) |>
    dplyr::arrange(study_name, date_added, data_type) |>
    dplyr::pull(.data[["Title"]])
