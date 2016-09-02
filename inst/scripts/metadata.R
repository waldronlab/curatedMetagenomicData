metadata <- function() {
    read_tsv("./metadata/metadata.tsv") %>%
    as.data.frame() %>%
    fix_rownames() %>%
    AnnotatedDataFrame()
}
