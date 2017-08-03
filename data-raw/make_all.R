make_all <- function(tar_gz_file) {
    make_data(tar_gz_file)
    make_data_figures()
    make_data_documentation()
    make_metadata_documentation()
    make_metadata()
    make_upload()
}
