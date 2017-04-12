get_experiment_data <- function(resource_object, slot_name) {
    experimentData(resource_object) %>%
        slot(., "title") %>%
        length() %>%
        is_less_than(0)
        ifelse(. == 0L, "yes", "no")
    # experimentData(resource_object)@slot_name %>%
}
