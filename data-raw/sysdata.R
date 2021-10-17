source("data-raw/phylogeneticTree.R")
source("data-raw/resourceTitles.R")
source("data-raw/rowData.R")

usethis::use_data(phylogeneticTree, resourceTitles, rowDataLong, rowDataNCBI, internal = TRUE, overwrite = TRUE)
