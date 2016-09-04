read_data <- function(tsv_file) {
    gsub(".tsv", "", basename(tsv_file)) %>%
    {read_tsv(tsv_file, col_names = c("rownames", .))}
}
