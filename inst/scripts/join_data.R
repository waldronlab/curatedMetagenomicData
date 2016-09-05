join_data <- function(x, y) {
    full_join(x, y, by = "rownames")
}
