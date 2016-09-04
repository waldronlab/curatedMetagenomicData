pathcoverage <- function() {
    dir_name <- "./pathcoverage"
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames() %>%
    bodysite_eset()
}
