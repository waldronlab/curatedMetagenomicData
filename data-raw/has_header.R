has_header <- function(data_type) {
    if(data_type == "genefamilies_relab") {
        return(TRUE)
    }
    if(data_type == "marker_abundance") {
        return(TRUE)
    }
    if(data_type == "marker_presence") {
        return(TRUE)
    }
    if(data_type == "metaphlan_bugs_list") {
        return(FALSE)
    }
    if(data_type == "pathabundance_relab") {
        return(FALSE)
    }
    if(data_type == "pathcoverage") {
        return(FALSE)
    }
}
