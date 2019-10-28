eset_name <- function(dataset_dir, data_type, bodysite) {
  basename(dataset_dir) %>%
    paste(., gsub("-", "_", data_type), gsub("-","_", bodysite), sep = ".")
}
