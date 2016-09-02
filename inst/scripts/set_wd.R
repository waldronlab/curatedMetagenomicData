set_wd <- function(tar_gz_file) {
    paste0("./tmp/", gsub(".tar.gz", "", basename(tar_gz_file))) %>%
    setwd()
}
