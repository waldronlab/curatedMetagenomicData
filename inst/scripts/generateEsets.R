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
      matrixList <- lapply(TSVsubset, function(x) {
        numericData <- fread(x, sep = "\t", header = TRUE, 
                             na.strings=c("NA", "na", "-", " -"),
                             data.table = FALSE)
        rownames(numericData) <- numericData[, 1]
        numericData[, -1, drop = FALSE]
      })
      mergedMatrix <- as.matrix(Reduce(merge, matrixList))
      phenoData <- AnnotatedDataFrame(phenoData[colnames(mergedMatrix), ])
      mergedExpression <- ExpressionSet(mergedMatrix, phenoData)
      bodySites <- unique(mergedExpression$bodysite)
      bplapply(bodySites, function(x) {
        toSave <- mergedExpression[, mergedExpression$bodysite == x]
        save(toSave, file = paste(toSave$dataset_name, toSave$bodysite,
                                  dataType, "eset", "rda", sep = "."))
      }, dataType = x)
    })
  })
}
