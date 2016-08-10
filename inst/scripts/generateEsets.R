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
        fread(x, sep = "\t", header = TRUE, na.strings=c("NA", "na", "-", " -"),
              data.table = FALSE)
      })
      mergedMatrix <- Reduce(function(x, y) merge(x, y, all.x = TRUE), matrixList)
      rownames(mergedMatrix) <- mergedMatrix[, 1]
      mergedMatrix2 <- as.matrix(mergedMatrix[, -1])
      phenoData2 <- AnnotatedDataFrame(phenoData[colnames(mergedMatrix), ])
      mergedExpression <- ExpressionSet(mergedMatrix2, phenoData2)
      bodySites <- unique(mergedExpression$bodysite)
      bplapply(bodySites, function(x) {
        toSave <- mergedExpression[, mergedExpression$bodysite == x]
        save(toSave, file = paste(toSave$dataset_name, toSave$bodysite,
                                  dataType, "eset", "rda", sep = "."))
      }, dataType = x)
    })
  })
}


