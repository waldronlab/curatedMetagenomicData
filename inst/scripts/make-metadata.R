make_metadata <- function() {
    create_dir("./inst/extdata")
    resource_list <- dir("./data")
    lapply(resource_list, metadata_row) %>%
    Reduce(rbind, .)
    write_csv(., "./inst/extdata/metadata.csv", append = TRUE)
}
