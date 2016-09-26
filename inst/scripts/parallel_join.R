parallel_join <- function(assay_list) {
    while (length(assay_list) > 1) {
        assay_length <- length(assay_list)
        even_assays <- assay_list[seq.int(2, assay_length, 2)]
        if(assay_length %% 2) {
            odds_assays <- assay_list[seq.int(1, assay_length - 1, 2)]
            last_assay <- assay_list[assay_length]
            assay_list <- bpmapply(join_assays, odds_assays, even_assays,
                                   SIMPLIFY = FALSE)
            assay_list <- c(assay_list, last_assay)
        } else {
            odds_assays <- assay_list[seq.int(1, assay_length, 2)]
            assay_list <- bpmapply(join_assays, odds_assays, even_assays,
                                   SIMPLIFY = FALSE)
        }
    }
    assay_list[[1]]
}
