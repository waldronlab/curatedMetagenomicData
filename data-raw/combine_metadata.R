combine_metadata <- function(tar_gz_file, metadata) {
    dataset_name <- format_dataset_name(tar_gz_file)
    metadata$dataset_name <- dataset_name
    metadata <- select(metadata, dataset_name, everything())
    if(file.exists("./data/combined_metadata.rda")) {
        load("./data/combined_metadata.rda")
        combined_metadata <- full_join(combined_metadata, metadata)
    } else {
        combined_metadata <- metadata
    }
    save(combined_metadata, file = "./data/combined_metadata.rda",
         compress = "gzip")
}
