metadata <- function(dataset_dir) {
    metadata_tsv <- paste0(dataset_dir, "metadata/metadata.tsv")
    guess_cols(metadata_tsv) %>%
    read_tsv(metadata_tsv, col_types = .)
}
