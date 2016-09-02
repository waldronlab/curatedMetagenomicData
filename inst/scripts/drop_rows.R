drop_rows <- function(assay_data) {
    assay_data[grep("\\|", assay_data[, 1], invert = TRUE), ]
}
