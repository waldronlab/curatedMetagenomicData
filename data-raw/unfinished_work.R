combined_metadata %>%
    filter(dataset_name == "HMP_2012") %>%
    ggplot(aes(bodysite)) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "ZellerG_2014") %>%
    ggplot(aes(disease)) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "HMP_2012") %>%
    ggplot(aes(age)) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "ZellerG_2014") %>%
    ggplot(aes(gender)) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "RampelliS_2015") %>%
    ggplot(aes(country)) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "Obregon_TitoAJ_2015") %>%
    ggplot(aes(bmi)) +
    geom_density() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "QinJ_2012") %>%
    ggplot(aes(height)) +
    geom_density() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "QinJ_2012") %>%
    ggplot(aes(weight)) +
    geom_density() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "QinJ_2012") %>%
    filter(!is.na(diabetic)) %>%
    ggplot(aes(diabetic)) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

combined_metadata %>%
    filter(dataset_name == "TettAJ_2016") %>%
    ggplot(aes(antibiotic_usage)) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
