sample_name <- function(tsv_file) {
    basename(tsv_file) %>%
    gsub(".tsv", "", .)
}
