parallel_join <- function(assay_list) {
    while (length(assay_list) > 1) {
        assay_length <- length(assay_list)
        even_assays <- assay_list[seq.int(2, assay_length, 2)]
        if(assay_length %% 2) {
            odds_assays <- assay_list[seq.int(1, assay_length - 1, 2)]
            last_assay <- assay_list[[assay_length]]
            bplapply(odds_assays, join_assays, even_assays)
        } else {
            odds_assays <- assay_list[seq.int(1, assay_length, 2)]
            bplapply(odds_assays, join_assays, even_assays)
        }
    }
}
