fix_rownames <- function(assay_data) {
    rownames(assay_data) <- assay_data[, 1]
    assay_data[, -1, drop = FALSE]
}
