has_header <- function() {
    if(dir_name == "./genefamilies_relab") {
        return(TRUE)
    }
    if(dir_name == "./marker_abundance") {
        return(TRUE)
    }
    if(dir_name == "./marker_presence") {
        return(TRUE)
    }
    if(dir_name == "./metaphlan_bugs_list") {
        return(FALSE)
    }
    if(dir_name == "./pathabundance_relab") {
        return(FALSE)
    }
    if(dir_name == "./pathcoverage") {
        return(FALSE)
    }
}
