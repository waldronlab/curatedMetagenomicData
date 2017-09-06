make_all <- function(tar_gz_file) {
    make_data(tar_gz_file)
    make_data_documentation()
    make_metadata_documentation()
    add_version_number()
    make_metadata()
    make_upload()
}
