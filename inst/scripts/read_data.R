read_data <- function(tsv_file) {
    sample_name <- gsub(".tsv", "", basename(tsv_file))
    guess_cols(tsv_file) %>%
    {read_tsv(tsv_file, col_names = c("rownames", sample_name), col_types = .)}
}
