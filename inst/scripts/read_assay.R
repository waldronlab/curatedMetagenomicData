read_assay <- function(tsv_file) {
    sample_name <- sample_name(tsv_file)
    guess_cols(tsv_file) %>%
    read_sample(tsv_file, sample_name, .)
}
