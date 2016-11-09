join_assays <- function(first_assay, second_assay) {
    full_join(first_assay, second_assay, by = "rownames")
}
