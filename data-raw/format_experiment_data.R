format_experiment_data <- function(metadata) {
    tryCatch(
        as_miame(metadata),
        error = function(e) {
            MIAME()
        }
    )
}
