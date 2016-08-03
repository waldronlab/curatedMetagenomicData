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
    matrixList <- bplapply(TSVfiles, function(x) {
      numericData <- fread(x, sep = "\t", header = TRUE, 
                           na.strings=c("NA", "nd", "-", " -"),
                           data.table = FALSE)
      rownames(numericData) <- numericData[, 1]
      numericData[, -1]
    })
    mergedMatrix <- as.matrix(Reduce(merge, matrixList))
    phenoData <- AnnotatedDataFrame(phenoData[colnames(mergedMatrix), ])
    mergedExpression <- ExpressionSet(mergedMatrix, phenoData)
    bodySites <- unique(mergedExpression$bodysite)
    bplapply(bodySites, function(x) {
      mergedExpression[, mergedExpression$bodysite == x]
    })
  })
}
