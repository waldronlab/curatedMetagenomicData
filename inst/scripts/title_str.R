title_str <- function(title_chr) {
    title_suffix <- paste("data from the", title_chr[1], "dataset")
    if(title_chr[2] == "genefamilies_relab") {
        title_str <- paste("Relabeled genefamilies", title_suffix)
        return(title_str)
    }
    if(title_chr[2] == "marker_abundance") {
        title_str <- paste("Marker abundance", title_suffix)
        return(title_str)
    }
    if(title_chr[2] == "marker_presence") {
        title_str <- paste("Marker presence", title_suffix)
        return(title_str)
    }
    if(title_chr[2] == "metaphlan_bugs_list") {
        title_str <- paste("Taxonomic abundance", title_suffix)
        return(title_str)
    }
    if(title_chr[2] == "pathabundance_relab") {
        title_str <- paste("Relabeled pathabundance", title_suffix)
        return(title_str)
    }
    if(title_chr[2] == "pathcoverage") {
        title_str <- paste("Pathcoverage", title_suffix)
        return(title_str)
    }
}
