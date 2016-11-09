save_eset <- function(bodysite, dataset_dir, data_type, merged_eset) {
    eset_name <- eset_name(dataset_dir, data_type, bodysite)
    assign(eset_name, merged_eset[, merged_eset$bodysite == bodysite])
    paste0("./data/", eset_name, ".rda") %>%
    save(list = eset_name, file = ., compress = "gzip")
}
