read_sample <- function(tsv_file, sample_name, col_types) {
    if (grepl("metaphlan_bugs_list", tsv_file)) {
        col_types <- "c-d-"
    }

    c("rownames", sample_name) %>%
    read_tsv(tsv_file, col_names = ., col_types = col_types, comment = "#")
}
