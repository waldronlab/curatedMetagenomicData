get_experiment_data <- function(resource_object, slot_name) {
    experimentData(resource_object) %>%
        slot(., slot_name) %>% {
            ifelse(length(.) > 1L, ., NA)
        }
}
