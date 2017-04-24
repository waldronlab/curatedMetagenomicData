parallel_rbind <- function(metadata_list) {
    while (length(metadata_list) > 1) {
        metadata_length <- length(metadata_list)
        even_elements <- metadata_list[seq.int(2, metadata_length, 2)]
        if(metadata_length %% 2) {
            odd_elements <- metadata_list[seq.int(1, metadata_length - 1, 2)]
            last_element <- metadata_list[metadata_length]
            metadata_list <- bpmapply(bind_rows, odd_elements, even_elements,
                                   SIMPLIFY = FALSE)
            metadata_list <- c(metadata_list, last_element)
        } else {
            odd_elements <- metadata_list[seq.int(1, metadata_length, 2)]
            metadata_list <- bpmapply(bind_rows, odd_elements, even_elements,
                                   SIMPLIFY = FALSE)
        }
    }
    metadata_list[[1]]
}
