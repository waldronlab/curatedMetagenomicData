sysdata <- function(tar_gz_file, metadata) {
    dataset_name <- format_dataset_name(tar_gz_file)
    metadata$dataset_name <- dataset_name
    metadata <- select(metadata, dataset_name, everything())
    if(file.exists("./R/sysdata.Rda")) {
        load("./R/sysdata.Rda")
        combined_metadata <- full_join(combined_metadata, metadata)
    } else {
        combined_metadata <- metadata
    }
    save(combined_metadata, file = "./R/sysdata.Rda", compress = "gzip")
}
