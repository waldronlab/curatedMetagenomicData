metadata_row <- function(resource_name) {
    resource_path <- paste0("./data/", resource_name)
    load(resource_path)
    Title <- strip_rda(resource_name)
    Description <- get_Description(resource_name)
    BiocVersion <- biocVersion()
    Genome <- ""
    SourceType <- "FASTQ"
    SourceUrl <- ""
    SourceVersion <- ""
    Species <- "Homo Sapiens"
    TaxonomyId <- "9606"
    Coordinate_1_based <- NA
    DataProvider <- experimentData(resource_name)@lab
    Maintainer <- get_Maintainer(resource_name)
    RDataClass <- class(resource_name)
    DispatchClass <- get_DispatchClass(resource_name)


    ResourceName <- get_resource_names()
    metadata <- data.frame(Title, Description, BiocVersion, Genome, SourceType,
                           SourceUrl, SourceVersion, Species, TaxonomyId,
                           Coordinate_1_based, DataProvider, Maintainer,
                           RDataClass, DispatchClass, ResourceName)

}
