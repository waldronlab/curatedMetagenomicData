base::dir(path = "inst/extdata", pattern = "[0-9]+", full.names = TRUE) |>
    purrr::map_dfr(~ readr::read_csv(.x, col_types = "ccccccccclccccccc")) |>
    readr::write_csv("inst/extdata/metadata.csv")
