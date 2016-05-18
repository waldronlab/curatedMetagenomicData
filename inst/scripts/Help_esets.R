# Declare it the working directory where rda files (annotated ones) are located.

eset.dir <- "."

## take marker_ab.eset.rda file(s) as a representative for a dataset
eset.files <- dir(eset.dir, pattern="^.*\\.marker_ab.eset.rda$")

## create a function to replace '%' in a string with '\\%', and convert non-ASCII text to "?"
cleanText <- function(x){
  gsub("%", "\\%", iconv(x, "latin1", "ASCII", sub="?"), fixed=TRUE)
}


for (iFile in 1:length(eset.files)){
  eset <- get(load(paste(eset.dir, eset.files[iFile],sep="/")))  #load the eset
  accessionID <- sub(".eset.rda", "", eset.files[iFile]) #get dataset name
  eset.name <- sub(".rda","",eset.files[iFile])

  ## generate alias tags
  mainName <- sub(".marker_ab", "", eset.name) #main name
  markerPres <- sub("marker_ab", "marker_pres", eset.name) #alias for marker_pres dataset
  abundance <- sub("marker_ab", "abundance", eset.name) #alias for abundance dataset
  pathCov <- sub("marker_ab", "pathCov", eset.name) #alias for pathCov dataset
  pathAbun <- sub("marker_ab", "pathAbun", eset.name) #alias for pathAbun dataset
  geneFam <- sub("marker_ab", "geneFam", eset.name) #alias for geneFam dataset
  print(accessionID) #print dataset name out in the console

  #do.call(rm, list( eset.files[iFile]))  #remove the original
  ##pdata.nonblank will contain pdata columns with any non-missing values:
  pdata.nonblank <- pData(eset)
  pdata.nonblank <- pdata.nonblank[ ,apply(pdata.nonblank, 2, function(x) sum(!is.na(x)) > 0)] #remove columns that only contain NA
  thisfile <- sub(".rda", ".Rd", eset.files[iFile]) #generate a file name with .Rd file extention
  thisfile <- sub(".marker_ab", "", thisfile) #clean up the .Rd file name

  dir.create("Help_Page") #create a directory name 'Help_Page'
  sink(file=paste("Help_Page", thisfile, sep="/")) #divert R output to an Rd file in Help_Page directory

  ## generate content in Rd file line by line
  cat(paste("\\name{", mainName, "}"))
  cat("\n")
  cat(paste("\\alias{", eset.name, "}"))
  cat("\n")
  cat(paste("\\alias{", markerPres, "}"))
  cat("\n")
  cat(paste("\\alias{", abundance, "}"))
  cat("\n")
  cat(paste("\\alias{", pathCov, "}"))
  cat("\n")
  cat(paste("\\alias{", pathAbun, "}"))
  cat("\n")
  cat(paste("\\alias{", geneFam, "}"))
  cat("\n")
  cat(paste("\\docType{data}"))
  cat("\n")

  ## add title to the Rd file
  cat(paste("\\title{", cleanText(experimentData(eset)@title), "}"))
  cat("\n")

  ## add abstract to the Rd file
  if (abstract(eset) != ""){
    cat(paste("\\description{", cleanText(experimentData(eset)@abstract), "}"))
    cat("\n")
  }

  ## add Usage information to the Rd file including experimentData, featureData, assayData, Platform type etc.
  cat(paste("\\usage{", cleanText(eset.name), "()}"))
  cat("\n")
  cat("\\format{")
  cat("\n")
  cat("\\preformatted{")
  cat("\n")
  cat("experimentData(eset):")
  cat("\n")
  print( experimentData(eset) )
  cat("\n")
  #cat(paste("Preprocessing:", experimentData(eset)@preprocessing[[1]]))
  #cat("\n")
  cat("featureData(eset):")
  cat("\n")
  print( featureData(eset) )
  cat("\n")
  cat("}}")
  cat("\n")
  cat("\\details{")
  cat("\n")
  cat("\\preformatted{")
  cat("\n")
  cat(paste("assayData:", nrow(eset),"features,",ncol(eset),"samples"))
  cat("\n")
  cat(paste("Platform type:", eset@annotation))
  cat("\n")

  ## calculate overall survival time-to-event summary (in years) and add to the Rd file
  if(!all(is.na(eset$vital_status))){
    time <- eset$days_to_death / 365
    cens <- ifelse(eset$vital_status=="deceased",1,0)
    library(survival)
    cat("Overall survival time-to-event summary (in years):")
    cat("\n")
    print(survfit(Surv(time,cens)~-1))
    cat("\n")
  }

  ## calculate Binary overall survival summary and add to the Rd file
  if(!all(is.na(eset$os_binary))){
    cat("Binary overall survival summary (definitions of long and short provided by study authors): \n")
    cat("\n")
    print(summary(factor(eset$os_binary)))
    cat("\n")
  }

  ## add other meta-data (if available) to the Rd file
  cat( "--------------------------- \n")
  cat( "Available sample meta-data: \n")
  cat( "--------------------------- \n")
  cat( "\n")
  if (ncol(pdata.nonblank) != 0){
    for (iCol in 1:ncol(pdata.nonblank)){
      if(length(unique(pdata.nonblank[,iCol])) < 6)
        pdata.nonblank[,iCol] <- factor(pdata.nonblank[,iCol])
      cat(paste(colnames(pdata.nonblank)[iCol],": \n",sep=""))
      print(summary(pdata.nonblank[,iCol]))
      cat( "\n")
    }
  } else {
    cat("None")
    cat( "\n")
  }
  cat("}}")
  cat("\n")

  ## add URL of experimentData to the Rd file
  if(experimentData(eset)@url != ""){
    cat(paste("\\source{", experimentData(eset)@url, "}"))
    cat("\n")
  }
  cat("\\keyword{datasets}")
  cat("\n")
  sink(NULL)
}

