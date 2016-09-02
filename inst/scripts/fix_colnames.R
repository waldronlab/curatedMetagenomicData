fix_colnames <- function(assay_data) {
    colnames(assay_data) <- gsub("_\\w+", "", colnames(assay_data))
    assay_data
}
