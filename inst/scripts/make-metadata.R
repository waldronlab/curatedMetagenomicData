make_metadata <- function() {
    Title <- ""
    Description <- ""
    BiocVersion <- biocVersion()
    Genome <- "HG-19"
    SourceType <- "fastq"
    SourceUrl <- ""
    SourceVersion <- ""
    Species <- "Homo Sapiens"
    TaxonomyId <- "9606"
    Coordinate_1_based <- ""
    DataProvider <- ""
    Maintainer <- ""
    RDataClass <- "ExpressionSet"
    DispatchClass <- "Rda"
    ResourceName <- basename(dir("./data/"))
    metadata <- data.frame(Title, Description, BiocVersion, Genome, SourceType,
                           SourceUrl, SourceVersion, Species, TaxonomyId,
                           Coordinate_1_based, DataProvider, Maintainer,
                           RDataClass, DispatchClass, ResourceName)
    write_csv(metadata, append = TRUE)
}
