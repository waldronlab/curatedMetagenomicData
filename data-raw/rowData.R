marker_info_file <-
    base::as.character("https://zenodo.org/record/5668382/files/mpa_v30_CHOCOPhlAn_201901_marker_info.txt.bz2")

marker_info_path <-
    base::tempfile()

utils::download.file(url = marker_info_file, destfile = marker_info_path)

marker_info_data <-
    readr::read_lines(marker_info_path, lazy = FALSE, progress = FALSE)

ncbi_id <-
    stringr::str_extract(marker_info_data, "[0-9]+")

rowname <-
    stringr::str_extract(marker_info_data, "k__.+(?=')")

to_keep <-
    stringr::str_replace_na(rowname, replacement = "t__") |>
    stringr::str_detect("t__", negate = TRUE)

ncbi_id <-
    magrittr::extract(ncbi_id, to_keep)

rowname <-
    magrittr::extract(rowname, to_keep)

marker_info_data <-
    base::data.frame(ncbi_id = ncbi_id, rowname = rowname) |>
    dplyr::distinct()

ncbi_id <-
    marker_info_data[["ncbi_id"]]

rowname <-
    marker_info_data[["rowname"]]

rank_names <-
    base::c("superkingdom", "phylum", "class", "order", "family", "genus", "species")

taxized <-
    taxize::classification(ncbi_id, db = "ncbi") |>
    purrr::map(~ dplyr::rename(.x, name = rank, value = name)) |>
    purrr::map(~ dplyr::select(.x, id, name, value)) |>
    purrr::map(~ dplyr::filter(.x, name %in% rank_names))

rowDataLong <-
    purrr::map(taxized, ~ dplyr::select(.x, name, value)) |>
    purrr::map_dfr(~ tidyr::pivot_wider(.x, values_from = "value")) |>
    dplyr::select(tidyselect::all_of(rank_names)) |>
    dplyr::mutate(across(.fns = ~ base::as.character(.x))) |>
    S4Vectors::DataFrame() |>
    magrittr::set_rownames(rowname)

rowDataNCBI <-
    purrr::map(taxized, ~ dplyr::select(.x, name, id)) |>
    purrr::map_dfr(~ tidyr::pivot_wider(.x, values_from = "id")) |>
    dplyr::select(tidyselect::all_of(rank_names)) |>
    dplyr::mutate(across(.fns = ~ base::as.integer(.x))) |>
    S4Vectors::DataFrame() |>
    magrittr::set_rownames(rowname)
