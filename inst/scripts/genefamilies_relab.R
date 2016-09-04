genefamilies_relab <- function() {
    dir_name <- "./genefamilies_relab"
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames() %>%
    drop_rows() %>%
    bodysite_eset()
}
