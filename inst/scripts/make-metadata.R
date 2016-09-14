make_metadata <- function() {
    create_dir("./inst/extdata")
    resource_list <- dir("./data")
    bplapply(resource_list, get_metadata) %>%
    Reduce(rbind, .) %>%
    write_csv(., "./inst/extdata/metadata.csv", append = TRUE)
}
