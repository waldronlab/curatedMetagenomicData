guess_cols <- function(tsv_file) {
    count_fields(tsv_file, tokenizer_tsv(), n_max = 1) %>%
    {paste0(rep("?", .), collapse = "")}
}
