make_metadata <- function() {
    ResourceName <- get_ResourceNames()
    ResourceName_length <- length(ResourceName)
    Title <- get_titles(ResourceName)
    Description <- rep("", ResourceName_length)
    BiocVersion <- get_biocVersion(ResourceName_length)
    Genome <- rep("", ResourceName_length)
    SourceType <- rep("", ResourceName_length)
    SourceUrl <- rep("", ResourceName_length)
    SourceVersion <- rep("", ResourceName_length)
    Species <- rep("", ResourceName_length)
    TaxonomyId <- rep("", ResourceName_length)
    Coordinate_1_based <- rep("", ResourceName_length)
    DataProvider <- rep("", ResourceName_length)
    Maintainer <- get_Maintainer(ResourceName_length)
    RDataClass <- get_RDataClasses(ResourceName)
    DispatchClass <- get_DispatchClasses(ResourceName)
    metadata <- data.frame(Title, Description, BiocVersion, Genome, SourceType,
                           SourceUrl, SourceVersion, Species, TaxonomyId,
                           Coordinate_1_based, DataProvider, Maintainer,
                           RDataClass, DispatchClass, ResourceName)
    create_dir("./inst/extdata")
    write_csv(metadata, "./inst/extdata/metadata.csv", append = TRUE)
}
