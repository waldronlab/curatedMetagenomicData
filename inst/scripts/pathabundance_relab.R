pathabundance_relab <- function() {
    dir_name <- "./pathabundance_relab"
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames() %>%
    bodysite_eset()
}
