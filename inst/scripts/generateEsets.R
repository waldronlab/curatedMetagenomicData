library(data.table)
library(BiocParallel)

generateEsets <- function(sourceDirectories, phenoData) {
  if(!is.list(sourceDirectories)) {
    stop("sourceDirectories must be of type list")
  }
  if(!is.character(phenoData)) {
    stop("phenoData must be of type character")
  }
  if(!any(as.logical(bplapply(sourceDirectories, dir.exists)))) {
    stop("sourceDirectories must be a list of directories")
  }
  if(!file.exists(phenoData)) {
    stop("phenoData file must be supplied")
  }
  tryCatch({
    phenoData <- fread(phenoData, sep = "\t", header = TRUE, data.table = FALSE)
  }, error = function(e) {
    stop("phenoData file cannot be read in", call. = FALSE)
  })
  
  bplapply(sourceDirectories, function(x) {
    TSVfiles <- as.list(list.files(x, pattern = "*.tsv", full.names = TRUE))
    dataTypes <- as.list(unique(gsub("(.+\\/\\w+_)(\\w+).+", "\\2", TSVfiles,
                                     perl = TRUE)))
    bplapply(dataTypes, function(x) {
      TSVsubset <- TSVfiles[grep(x, TSVfiles)]
      sampleList <- bplapply(TSVsubset, function(x) {
        readSample <- fread(x, sep = "\t", header = TRUE, 
                            na.strings=c("NA", "na", "-", " -"),
                            data.table = FALSE)
        readSample[grep("\\|", readSample[, 1], invert = TRUE), ]
        #rownames(readSample) <- readSample[, 1]
        #readSample[, -1, drop = FALSE]
      })
      #make a big blank matrix and fill it out
      mergedSamples <- Reduce(function(x, y) merge(x, y, all.x = TRUE), 
                             sampleList)
      rownames(mergedSamples) <- mergedSamples[, 1]
      mergedSamples <- as.matrix(mergedSamples[, -1])
      colnames(mergedSamples) <- gsub("_Abundance", "", colnames(mergedSamples))
      phenoData <- AnnotatedDataFrame(phenoData[match(colnames(mergedSamples), 
                                                      phenoData$sampleID), ])
      rownames(phenoData) <- phenoData$sampleID
      mergedExpression <- ExpressionSet(mergedSamples, phenoData)
      bodySites <- unique(mergedExpression$bodysite)
      bplapply(bodySites, function(x, dataType) {
        toSave <- mergedExpression[match(mergedExpression$bodysite, x), ]
        save(toSave, file = paste(toSave$dataset_name[1], toSave$bodysite[1],
                                  dataType, "eset", "rda", sep = "."))
      }, dataType = x)
    })
  })
}
