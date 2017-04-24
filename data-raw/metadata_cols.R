metadata_cols <- function(metadata_tsv) {
    template_csv <- read_csv("./inst/extdata/template.csv")
    read_lines(metadata_tsv, n_max = 1) %>%
    strsplit("\t") %>%
    unlist() %>%
    match(template_csv$col.name) %>%
    template_csv$var.class[.] %>%
    strtrim(1) %>%
    paste0(collapse = "")
}
