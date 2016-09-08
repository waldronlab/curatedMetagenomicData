make_metadata <- function() {
    dataset_list <- dataset_list()
    dataset_length <- dataset_length(dataset_list)
    Title <- get_titles(dataset_list)
    Description <- rep("", dataset_length)
    BiocVersion <- get_biocVersion(dataset_length)
    Genome <- rep("", dataset_length)
    SourceType <- rep("", dataset_length)
    SourceUrl <- rep("", dataset_length)
    SourceVersion <- rep("", dataset_length)
    Species <- rep("", dataset_length)
    TaxonomyId <- rep("", dataset_length)
    Coordinate_1_based <- rep("", dataset_length)
    DataProvider <- rep("", dataset_length)
    Maintainer <- read.dcf("DESCRIPTION", "Maintainer")
    RDataClass <- get_RDataClasses()
    DispatchClass <- get_DispatchClasses()
    ResourceName <- get_ResourceNames()
    metadata <- data.frame(Title, Description, BiocVersion, Genome, SourceType,
                           SourceUrl, SourceVersion, Species, TaxonomyId,
                           Coordinate_1_based, DataProvider, Maintainer,
                           RDataClass, DispatchClass, ResourceName)
    write_csv(metadata, "./inst/extdata/metadata.csv", append = TRUE)
}
