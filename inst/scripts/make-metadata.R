make_metadata <- function() {
    create_dir("./inst/extdata")
    resource_list <- dir("./data")
    resource_maintainer <- read.dcf("DESCRIPTION", "Maintainer")
    bplapply(resource_list, get_metadata, resource_maintainer) %>%
    Reduce(bind_rows, .) %>%
    write_csv(., "./inst/extdata/metadata.csv", append = TRUE)
}
