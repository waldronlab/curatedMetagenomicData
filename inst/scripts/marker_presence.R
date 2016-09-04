marker_presence <- function() {
    dir_name <- "./marker_presence"
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames() %>%
    bodysite_eset()
}
