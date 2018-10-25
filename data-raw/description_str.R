description_str <- function(description_chr) {
    description_suffix <- paste("data from the", description_chr[2],
                                "dataset specific to the", description_chr[4],
                                "body site.")
    if(description_chr[3] == "genefamilies_relab") {
        description_str <- paste("Relabeled genefamilies", description_suffix)
        return(description_str)
    }
    if(description_chr[3] == "marker_abundance") {
        description_str <- paste("Marker abundance", description_suffix)
        return(description_str)
    }
    if(description_chr[3] == "marker_presence") {
        description_str <- paste("Marker presence", description_suffix)
        return(description_str)
    }
    if(description_chr[3] == "metaphlan_bugs_list") {
        description_str <- paste("Taxonomic abundance", description_suffix)
        return(description_str)
    }
    if(description_chr[3] == "pathabundance_relab") {
        description_str <- paste("Relabeled pathabundance", description_suffix)
        return(description_str)
    }
    if(description_chr[3] == "pathcoverage") {
        description_str <- paste("Pathcoverage", description_suffix)
        return(description_str)
    }

}
