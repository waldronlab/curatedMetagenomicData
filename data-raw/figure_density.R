figure_density <- function(current_dataset, filtered_data) {
    current_variable <- colnames(filtered_data)[2]
    
    filtered_data %>%
        filter(dataset_name == current_dataset) %>%
        ggplot(aes(get(current_variable))) +
        geom_density() +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab(current_variable)
    
    paste(current_dataset, current_variable, "png", sep = ".") %>%
        paste0("./man/figures/", .) %>%
        ggsave()
}
