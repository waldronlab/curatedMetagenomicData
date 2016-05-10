# Script to read HUMAnN2 output file; i.e. Zeller.tar.bz2
#Functions to be loaded before running the script given below (line 137)


getListFileFromTarBz2 <- function(tarbz2File=tarbz2File){ 
  library(data.table)
  listFiles <- untar(tarbz2File,
                     compressed = 'bzip2',
                     list=TRUE)
  return (listFiles)
}


split_path <- function(path, mustWork = FALSE, rev = FALSE) {
    output <- c(strsplit(dirname(normalizePath(path,mustWork = mustWork)),
                                             "/|\\\\")[[1]], basename(path))
    ifelse(rev, return(rev(output)), return(output))
}


processTarBz2ByDatatype_batch <- function(tarbz2FileOutdir,
                                          data.type=c("genefamilies", "pathabundance", "pathcoverage")){ 
  library(data.table)
  
  tarbz2Dir <- getListFileFromTarBz2(tarbz2FileOutdir)[1]
  untar(tarbz2FileOutdir, compressed = 'bzip2')
  
  tarbz2Files <- list.files(tarbz2Dir, pattern="*.bz2", full.names=TRUE)  
  
  for (i in 1:length(tarbz2Files)){
    tarbz2File <- tarbz2Files[i]
    untar(tarbz2File,
          compressed = 'bzip2', 
          exdir='./tmp',
          list=FALSE)
  }
  
  tsvfiles <- list.files('./tmp', pattern="*.tsv", full.names=TRUE, recursive = TRUE)  
  tsvfiles.sel <- tsvfiles[grep(data.type, tsvfiles)]
  
  list.df <- list()  
  for (i in 1:length(tsvfiles.sel)){
    # skip the header line
    print(i)
    numeric.dat <- fread(tsvfiles.sel[i], data.table=FALSE, header=TRUE, na.strings=c("NA", "nd", "-", " -"), skip=0)
    family <- numeric.dat[, 1]
    #sampName <- colnames(numeric.dat)[-1]
    #get sampName from directory name (this is to get correct sample names for WT2D dataset)
    filepathname <- tsvfiles.sel[i]
    sampName <- split_path(filepathname, rev=TRUE)[3] 
    sampName <- sub('_sra', '', sampName) 
    sampName <- sub('_tar_bz2', '', sampName) 

    numeric.dat <- numeric.dat[, -1]
    numeric.dat <- as.matrix(numeric.dat)
    
    colnames(numeric.dat) <- sampName
    rownames(numeric.dat) <- family
    
    list.df[[i]] <- numeric.dat
  }
  system("rm -r ./tmp")
  return (list.df)
}


mergeListDataframe <- function(list.dataframe){
  library(data.table)
  df <- as.data.frame(list.dataframe[[1]])
  for (i in 2:length(list.dataframe)){
    print(i)
    df <- data.table(df, keep.rownames=TRUE, key="rn")
    #df <- merge(df, as.data.frame(list.dataframe[[i]]), all=TRUE, by=0)
    df <- merge(df, data.table(as.data.frame(list.dataframe[[i]]), keep.rownames=TRUE, key="rn"), all=TRUE)
    #rownames(df) <- df$Row.names
  }
  df <- as.data.frame(df)
  rownames(df) <- df[,1]
  df <- df[,-1]
  return (df)
}

generateEset <- function(assay.data, phenotype.data=NULL, 
                         experiment.data=NULL){
  library(affy)
  assay.data <- as.matrix(assay.data)
  phenotype.data <- phenotype.data[colnames(assay.data), ]  
  
  if (!is.null(phenotype.data)){
    eset <- ExpressionSet(assayData=assay.data, 
                          phenoData=AnnotatedDataFrame(phenotype.data))    
  } else {
    eset <- ExpressionSet(assayData=assay.data)
  }
  
  return (eset)
}

generateEsetByBodysite <- function(assay.data, data.type=c("pathcoverage"), phenotype.data=NULL,
                                   experiment.data=NULL){
  library(affy)
  assay.data <- as.matrix(assay.data)
  phenotype.data <- phenotype.data[colnames(assay.data), ]
  
  if (!is.null(phenotype.data)){
    eset <- ExpressionSet(assayData=assay.data,
                          phenoData=AnnotatedDataFrame(phenotype.data))
  } else {
    eset <- ExpressionSet(assayData=assay.data)
  }
  
  #create subeset by bodysite: file named 'dataset_name.bodysite.datatype.eset.rda
  outdirname <- paste(data.type, "subesets", sep='_')
  print(paste("creating directory", outdirname, sep=" "))
  dir.create(outdirname, showWarnings = FALSE)
  
  for (i in 1:length(unique(eset$dataset_name))){
    #get dataset_name
    datname <- unique(eset$dataset_name)[i]
    
    for (j in 1:length(unique(eset[, eset$dataset_name == datname]$bodysite))){
      #get body site for each dataset_name
      bodysite <- unique(eset[, eset$dataset_name == datname]$bodysite)[j]
      
      #generate sub eset for each dataset_name and bodysite
      sub_eset <- eset[, eset$dataset_name == datname & eset$bodysite == bodysite]
      sub_eset_name <- paste(datname, bodysite, data.type, "eset", sep=".")
      print(paste("working on: ", sub_eset_name))
      assign(sub_eset_name, sub_eset)
      outfname <- paste(datname, bodysite, data.type, "eset","rda", sep=".")
      
      save(list = sub_eset_name, file=paste(outdirname, outfname, sep="/"))
    }
  }
}

Dat <- read.table("Pheno_Data.txt", sep='\t', header=TRUE, stringsAsFactors = FALSE)

tarbz2FileOutdir <- "./Zeller.tar.bz2"
humann2.geneFam <- processTarBz2ByDatatype_batch(tarbz2FileOutdir, data.type=c("genefamilies"))
humann2.pathAbun <- processTarBz2ByDatatype_batch(tarbz2FileOutdir, data.type=c("pathabundance"))
humann2.pathCov <- processTarBz2ByDatatype_batch(tarbz2FileOutdir, data.type=c("pathcoverage"))

flat.df.geneFam <- mergeListDataframe(humann2.geneFam)
flat.df.pathAbun <- mergeListDataframe(humann2.pathAbun)
flat.df.pathCov <- mergeListDataframe(humann2.pathCov)

generateEsetByBodysite(flat.df.geneFam, phenotype.data=Dat, experiment.data=NULL, data.type=c("genefamilies"))
generateEsetByBodysite(flat.df.pathAbun, phenotype.data=Dat, experiment.data=NULL, data.type=c("pathabundance"))
generateEsetByBodysite(flat.df.pathCov, phenotype.data=Dat, experiment.data=NULL, data.type=c("pathcoverage"))


