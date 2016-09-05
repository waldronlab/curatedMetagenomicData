dataset_dir <- function(tar_gz_file) {
    basename(tar_gz_file) %>%
    gsub(".tar.gz", "", .) %>%
    paste0("./tmp/", ., "/")
}
