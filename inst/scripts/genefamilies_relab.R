genefamilies_relab <- function() {
    dir_name <- "./genefamilies_relab"
    assay_merge() %>%
    drop_rows() %>%
    fix_rownames() %>%
    fix_colnames() %>%
    bodysite_eset()
}
