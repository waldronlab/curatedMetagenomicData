marker_abundance <- function() {
    dir_name <- "./marker_abundance"
    assay_merge() %>% #replace rowname
    fix_rownames() %>%
    fix_colnames() %>%
    bodysite_eset()
}
