make_all <- function(tar_gz_file) {
    make_data(tar_gz_file)
    make_documentation()
    make_metadata()
    make_upload()
}
