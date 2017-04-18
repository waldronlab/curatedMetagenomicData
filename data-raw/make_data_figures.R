make_data_figures <- function() {
    bodysite_data <-
        combined_metadata %>%
        filter(!is.na(bodysite)) %>%
        select(dataset_name, bodysite)
    
    unique(bodysite_data$dataset_name) %>%
        lapply(., figure_bar, bodysite_data)
    
    disease_data <-
        combined_metadata %>%
        filter(!is.na(disease)) %>%
        select(dataset_name, disease)
    
    unique(disease_data$dataset_name) %>%
        lapply(., figure_bar, disease_data)
    
    age_data <-
        combined_metadata %>%
        mutate(age = round(age)) %>%
        filter(!is.na(age)) %>%
        select(dataset_name, age)
    
    unique(age_data$dataset_name) %>%
        lapply(., figure_bar, age_data)
    
    gender_data <-
        combined_metadata %>%
        filter(!is.na(gender)) %>%
        select(dataset_name, gender)
    
    unique(gender_data$dataset_name) %>%
        lapply(., figure_bar, gender_data)
    
    country_data <-
        combined_metadata %>%
        filter(!is.na(country)) %>%
        select(dataset_name, country)
    
    unique(country_data$dataset_name) %>%
        lapply(., figure_bar, country_data)
    
    bmi_data <-
        combined_metadata %>%
        filter(!is.na(bmi)) %>%
        select(dataset_name, bmi)
    
    unique(bmi_data$dataset_name) %>%
        lapply(., figure_density, bmi_data)
    
    height_data <-
        combined_metadata %>%
        filter(!is.na(height)) %>%
        select(dataset_name, height)
    
    unique(height_data$dataset_name) %>%
        lapply(., figure_density, height_data)
    
    weight_data <-
        combined_metadata %>%
        filter(!is.na(weight)) %>%
        select(dataset_name, weight)
    
    unique(weight_data$dataset_name) %>%
        lapply(., figure_density, weight_data)
    
    diabetic_data <-
        combined_metadata %>%
        filter(!is.na(diabetic)) %>%
        select(dataset_name, diabetic)
    
    unique(diabetic_data$dataset_name) %>%
        lapply(., figure_bar, diabetic_data)
    
    antibiotic_usage_data <-
        combined_metadata %>%
        filter(!is.na(antibiotic_usage)) %>%
        select(dataset_name, antibiotic_usage)
    
    unique(antibiotic_usage_data$dataset_name) %>%
        lapply(., figure_bar, antibiotic_usage_data)
    
    invisible(NULL)
}
