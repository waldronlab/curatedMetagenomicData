parallel_rbind <- function(metadata_list) {
    while (length(metadata_list) > 1) {
        metadata_length <- length(metadata_list)
        even_elements <- metadata_list[seq.int(2, metadata_length, 2)]
        if(metadata_length %% 2) {
            odds_elements <- metadata_list[seq.int(1, metadata_length - 1, 2)]
            last_element <- metadata_list[metadata_length]
            metadata_list <- bpmapply(bind_rows, odds_elements, even_elements,
                                   SIMPLIFY = FALSE)
        } else {
            odds_elements <- metadata_list[seq.int(1, metadata_length, 2)]
            metadata_list <- bpmapply(bind_rows, odds_elements, even_elements,
                                   SIMPLIFY = FALSE)
        }
    }
    if(exists("last_element")) {
        first_element <- metadata_list[[1]]
        second_element <- last_element[[1]]
        bind_rows(first_element, second_element)
    } else {
        metadata_list[[1]]
    }
}
