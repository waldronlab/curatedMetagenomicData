read_sample <- function(tsv_file, sample_name, col_types) {
    c("rownames", sample_name) %>%
    read_tsv(tsv_file, col_names = ., col_types = col_types, skip = 1)
}
