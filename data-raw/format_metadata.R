format_metadata <- function(dataset_dir) {
    metadata_tsv <- paste0(dataset_dir, "metadata/metadata.tsv")
    metadata_cols(metadata_tsv) %>%
    gsub("i", "d", x = .) %>%
    read_tsv(metadata_tsv, col_types = ., na = c("", "NA", "na", "nA", "Na"))
}
