### =========================================================================
### curatedMetagenomicData metadata 
### -------------------------------------------------------------------------
###

dat <- read.table("Pheno_Data.txt", sep='\t', TRUE, stringsAsFactors = FALSE)
lst <- split(dat, dat$dataset_name)

dataset <- c("Candela_Africa", "Chatelier_gut_obesity",
             "Loman2013_EcoliOutbreak_DNA_HiSeq", 
             "Loman2013_EcoliOutbreak_DNA_MiSeq",
             "Neilsen_genome_assembly", "Quin_gut_liver_cirrhosis",
             "Tito_subsistence_gut", "WT2D", "Zeller_fecal_colorectal_cancer",
             "hmp", "t2dmeta_long", "t2dmeta_short")
datatype <- c("abundance", "genefamilies", "marker_ab", 
              "marker_pres", "pathabundance", "pathcoverage")
resource <- sapply(dataset,
                 function(ds) {
                     chunk <- lst[[ds]]
                     bodysite <- unique(chunk$bodysite)
                     xx <- paste0(ds, ".", unique(chunk$bodysite), ".")
                     sapply(xx, 
                         function(yy) paste0(yy, datatype, ".eset.rda"))
                 })

meta <- data.frame(
    Title = unlist(resource, use.names=FALSE),
    Description = paste0("Human microbiome relative abundance of taxonimic ",
                         "markers from multiple body sites"),
    BiocVersion = "3.3",
    Genome = "",
    SourceType = "",
    SourceUrl = "",
    SourceVersion = "",
    Species = "Homo sapiens",
    TaxonomyId = 9606,
    Coordinate_1_based = TRUE,
    DataProvider = "",
    Maintainer = "Levi Waldron <levi.waldron@hunter.cuny.edu>",
    RDataClass = "ExpressionSet",
    DispatchClass = "ExpressionSet")

write.csv(meta, file="metadata.csv", row.names=FALSE)
