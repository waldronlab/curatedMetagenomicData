guess_cols <- function(tsv_file) {
    tokenizer_tsv() %>%
    count_fields(tsv_file, ., n_max = 1) %>%
    rep("?", .) %>%
    paste0(., collapse = "")
}
