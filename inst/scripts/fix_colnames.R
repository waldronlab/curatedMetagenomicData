fix_colnames <- function(assay_data) {
    if(has_header()){
        assay_data <- assay_data[-1, ]
    }
    assay_data
}
