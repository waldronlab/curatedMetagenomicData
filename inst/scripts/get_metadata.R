get_metadata <- function(resource_name) {
    resource_object <- get_resource(resource_name)
    Title <- gsub(".rda", "", resource_name)
    Description <- get_Description(resource_name)
    BiocVersion <- biocVersion()
    Genome <- as.character("")
    SourceType <- as.character("FASTQ")
    SourceUrl <- as.character("")
    SourceVersion <- as.character("")
    Species <- as.character("Homo Sapiens")
    TaxonomyId <- as.character("9606")
    Coordinate_1_based <- as.logical(NA)
    DataProvider <- experimentData(resource_object)@lab
    Maintainer <- read.dcf("DESCRIPTION", "Maintainer")
    RDataClass <- class(resource_object)
    DispatchClass <- get_DispatchClass(resource_name)
    ResourceName <- as.character(resource_name)
    Tags <-
    data.frame(Title, Description, BiocVersion, Genome, SourceType, SourceUrl,
               SourceVersion, Species, TaxonomyId, Coordinate_1_based,
               DataProvider, Maintainer, RDataClass, DispatchClass,
               ResourceName, Tags)
}
