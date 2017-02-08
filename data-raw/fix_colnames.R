fix_colnames <- function(assay_data, data_type) {
    if(has_header(data_type)){
        assay_data <- assay_data[-1, ]
    }
    assay_data
}
