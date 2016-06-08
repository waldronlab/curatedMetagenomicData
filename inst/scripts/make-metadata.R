### =========================================================================
### curatedMetagenomicData metadata 
### -------------------------------------------------------------------------
###

## Pheno_Data
pdat <- read.table("Pheno_Data.txt.bz2", sep='\t', TRUE, 
                  stringsAsFactors=FALSE)
lst <- split(pdat, pdat$dataset_name)
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

## Experiment_Data
## Get DataProvider field
## FIXME: can these be modified in Experiment_Data.txt.bz2?
edat <- read.table("Experiment_Data.txt.bz2", sep='\t', TRUE, 
                   stringsAsFactors=FALSE)
provider <- rep(NA_character_, length(dataset))
valid <- dataset %in% edat$study
provider[valid] <- edat$Laboratory[match(dataset, edat$study)]
provider[dataset == "Neilsen_genome_assembly"] <- "1] Center for Biological Sequence Analysis, [2] Novo Nordisk Foundation Center for Biosustainability, Technical University of Denmark, Kongens Lyngby, Denmark."
provider[dataset == "Quin_gut_liver_cirrhosis"] <- "1] State Key Laboratory for Diagnosis and Treatment of Infectious Disease, [2] Collaborative Innovation Center for Diagnosis and Treatment of Infectious Diseases, Zhejiang University, 310003 Hangzhou, China."
stopifnot(length(provider) == length(resource))

meta <- data.frame(
    Title = unlist(resource, use.names=FALSE),
    Description = paste0("Human microbiome relative abundance of taxonimic ",
                         "markers from multiple body sites"),
    BiocVersion = "3.4",
    Genome = "",
    SourceType = "",
    SourceUrl = "",
    SourceVersion = "",
    Species = "Homo sapiens",
    TaxonomyId = 9606,
    Coordinate_1_based = TRUE,
    DataProvider = rep.int(provider, times=lengths(resource)),
    Maintainer = "Levi Waldron <levi.waldron@hunter.cuny.edu>",
    RDataClass = "ExpressionSet",
    DispatchClass = "ExpressionSet")

write.csv(meta, file="metadata.csv", row.names=FALSE)
