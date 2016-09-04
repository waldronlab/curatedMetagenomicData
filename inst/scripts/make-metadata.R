make_metadata <- function() {
    Title <- ""
    Description <- ""
    BiocVersion <- ""
    Genome <- ""
    SourceType <- ""
    SourceUrl <- ""
    SourceVersion <- ""
    Species <- ""
    TaxonomyId <- ""
    Coordinate_1_based <- ""
    DataProvider <- ""
    Maintainer <- ""
    RDataClass <- ""
    DispatchClass <- ""
    ResourceName <- ""
    metadata <- data.frame(Title, Description, BiocVersion, Genome, SourceType,
                           SourceUrl, SourceVersion, Species, TaxonomyId,
                           Coordinate_1_based, DataProvider, Maintainer,
                           RDataClass, DispatchClass, ResourceName)
    write_csv(metadata, append = TRUE)
}
