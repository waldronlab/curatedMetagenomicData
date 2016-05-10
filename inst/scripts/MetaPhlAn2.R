# Script to read a MetaPhlAn2 output file. E.g. "merge_marker_ab_table.metadata_NV.txt" and create an ExpressionSet.

#install.packages("data.table")
library(data.table)
numeric.dat <- fread("merge_marker_ab_table.metadata_NV.txt", data.table=FALSE, header=FALSE, na.strings=c("NA", "nd", "-", " -"), skip=211)

rownames(numeric.dat) <- numeric.dat[, 1]
numeric.dat <- numeric.dat[, -1]
numeric.dat <- as.matrix(numeric.dat)

pheno.dat <- fread("merge_marker_ab_table.metadata_NV.txt", data.table=FALSE, header=FALSE, na.strings=c("NA", "nd", "-", " -"), nrow=211)

pheno.dat[4, is.na(pheno.dat[4, ])] <- "stool"

pheno.dat <- t(pheno.dat)
colnames(pheno.dat) <- pheno.dat[1, ]
pheno.dat <- pheno.dat[-1, ]

rownames(pheno.dat) <- make.unique(paste(pheno.dat[, 2]))
pheno.dat <- data.frame(pheno.dat, stringsAsFactors=FALSE)

colnames(numeric.dat) <- rownames(pheno.dat)

library(affy)

eset <- ExpressionSet(assayData=numeric.dat, phenoData=AnnotatedDataFrame(pheno.dat))
save(eset, file='merge_marker_ab_table.metadata_NV.eset.rda')
featureNames(eset)
sampleNames(eset)

## Function to Generate the sub_esets.

# Change datatype accordingly. E.g. Use datatype="abundance" for abundance dataset.
generateSubEset <- function(eset=eset, datatype="marker"){
  outdirname <- paste(datatype, "subesets", sep='_')
  print(paste("creating directory", outdirname, sep=" "))
  dir.create(outdirname, showWarnings = FALSE)
  
  for (i in 1:length(unique(eset$dataset_name))){
    datname <- unique(eset$dataset_name)[i]
    
    for (j in 1:length(unique(eset[, eset$dataset_name == datname]$bodysite))){
      bodysite <- unique(eset[, eset$dataset_name == datname]$bodysite)[j]
      
      sub_eset <- eset[, eset$dataset_name == datname & eset$bodysite == bodysite]
      sub_eset_name <- paste(datname, bodysite, datatype, "eset", sep=".")
      print(paste("working on: ", sub_eset_name))
      assign(sub_eset_name, sub_eset)
      outfname <- paste(datname, bodysite, datatype, "eset","rda", sep=".")
      
      save(list = sub_eset_name, file=paste(outdirname, outfname, sep="/")) 
    } 
  }  
}
# Use datatype="abundance" for abundance dataset and "marker_pres" for marker_pres dataset.
generateSubEset(eset, datatype="marker_ab")



