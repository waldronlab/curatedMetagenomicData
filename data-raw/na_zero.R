na_zero <- function(assay_data) {
    assay_data[is.na(assay_data)] <- 0
    assay_data
}
