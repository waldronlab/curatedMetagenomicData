description_str <- function(description_chr) {
    description_suffix <- paste("data from the", description_chr[1],
                                "dataset specific to the", description_chr[3],
                                "bodysite.")

    if(description_chr[2] == "genefamilies_relab") {
        paste("Relabeled genefamilies", description_suffix) %>%
        return()
    }
    if(description_chr[2] == "marker_abundance") {
        paste("Marker abundance", description_suffix) %>%
        return()
    }
    if(description_chr[2] == "marker_presence") {
        paste("Marker presence", description_suffix) %>%
        return()
    }
    if(description_chr[2] == "metaphlan_bugs_list") {
        paste("Taxonomic abundance", description_suffix) %>%
        return()
    }
    if(description_chr[2] == "pathabundance_relab") {
        paste("Relabeled pathabundance", description_suffix) %>%
        return()
    }
    if(description_chr[2] == "pathcoverage") {
        paste("Pathcoverage", description_suffix) %>%
        return()
    }
}
