format_dataset_name <- function(tar_gz_file) {
    basename(tar_gz_file) %>%
    gsub(".tar.gz", "", .)
}
