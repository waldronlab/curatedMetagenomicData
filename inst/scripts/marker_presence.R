marker_presence <- function(pheno_data) {
    dir_name <- "./marker_presence"
    assay_merge() %>%
    fix_rownames() %>%
    fix_colnames() %>%
    bodysite_eset(., pheno_data, dir_name)
}
