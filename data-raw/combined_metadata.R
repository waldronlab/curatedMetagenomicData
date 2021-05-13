# REMOVE THIS FILE AFTER RELEASE_3_13
base::load("data/sampleMetadata.rda")

combined_metadata <-
    sampleMetadata

usethis::use_data(combined_metadata, overwrite = TRUE)
