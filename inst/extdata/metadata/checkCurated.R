## R CMD BATCH --vanilla checkCurated.R template_metagenomic.csv

inputargs <- commandArgs(TRUE)
curated.dir <- inputargs[1]
template.file <- inputargs[2]
output.dir <- paste(curated.dir,"/ERRORS",sep="")

if(!file.exists(output.dir)) dir.create(output.dir,recursive=TRUE)

##the template to use
template <- read.csv(template.file, as.is=TRUE)

##the list of filenames to check
files <- dir(curated.dir,pattern="\\.txt$")

##Create a checklist for three checks in all files
checklist <- matrix(NA,ncol=2,nrow=length(files))
colnames(checklist) <- c("column.names","variable.regex.checks")
rownames(checklist) <- files

##-------------------------------------------------
##check that the column names match the template
##-------------------------------------------------
for (i in 1:length(files)){
  print(paste("Checking column names in",files[i]))
  curated <- read.delim(paste(curated.dir,files[i],sep="/"),as.is=TRUE)
  ##check column names
  if(identical(all.equal(colnames(curated),template$col.name),TRUE)){
    print("column names OK")
    checklist[i,"column.names"] <- TRUE
  }else{
    all.equal(colnames(curated),template$col.name)
    print("Column names should be: ")
    print(template$col.name)
    print("Column names are: ")
    print(colnames(curated))
    checklist[i,"column.names"] <- FALSE
  }
}

##-------------------------------------------------
##construct the regexes from template$allowedvalues
##-------------------------------------------------
regexes <- template$allowedvalues
regexes <- paste("^",regexes,"$",sep="")
regexes <- gsub("|","$|^",regexes,fixed=TRUE)
##regexes[template$requiredness=="optional"] <- paste(regexes[template$requiredness=="optional"],"|^NA$",sep="")
regexes[grepl("^*$",regexes,fixed=TRUE)] <- "."
names(regexes) <- template$col.name
if(any(grepl("decimal", regexes)))
    regexes[grepl("decimal",regexes)] <- "^[0-9]+\\.?[0-9]*$"
if(any(grepl("integer", regexes)))
    regexes[grepl("integer", regexes)] <- "^[0-9]+$"
if(any(grepl("decimalonly", regexes)))
    regexes[grepl("decimalonly",regexes)] <- "^[0-9]+\\.{1}[0-9]*$"

##remove previously existing regexerrors files
unlink(paste(output.dir,"/regexerrors*.txt",sep=""))

##-------------------------------------------------
##Check the data entries in each column for regex
## matching, uniqueness, and missingness
##-------------------------------------------------
for (i in which(checklist[,"column.names"])){
  print(paste("Checking regexes in",files[i]))
  curated <- read.delim(paste(curated.dir,files[i],sep="/"),as.is=TRUE)
  ##check column names
  column.OK <- rep(NA,ncol(curated))
  names(column.OK) <- colnames(curated)
  for(j in 1:ncol(curated)){
    doesmatch <- grep(regexes[j],curated[,j])
    if(template[j,"requiredness"]=="optional"){
      doesmatch <- c(doesmatch,which(is.na(curated[,j])))
    }
    doesnotmatch <- 1:nrow(curated)
    doesnotmatch <- doesnotmatch[!doesnotmatch %in% doesmatch]
    ## if field must be unique, add non-unique values to doesnotmatch
    if(template[j,"uniqueness"]=="unique"){
      counts.table <- table(curated[,j])
      counts <- counts.table[match(curated[,j],names(counts.table))]  #this counts the occurences
      counts[is.na(counts)] <- 1  ##Consider NAs to be unique
      nonunique <- which(counts>1)
      doesnotmatch <- c(doesnotmatch,nonunique)
      doesnotmatch <- unique(doesnotmatch)  #don't duplicate fields which fail both tests
    }
    if(length(doesnotmatch)==0){
      column.OK[j] <- TRUE
    }else{
      column.OK[j] <- FALSE
      curated[doesnotmatch,j] <- paste("!!!",curated[doesnotmatch,j],"!!!",sep="")
    }
  }
  if(all(column.OK)){
    print("all regex checks OK")
    checklist[i,"variable.regex.checks"] <- TRUE
  }else{
    print(paste("The following columns failed the regex check for ",files[i],":",sep=""))
    print(names(column.OK)[!column.OK])
    print(curated[,!column.OK])
    write.table(curated[,!column.OK],paste(output.dir,"/regexerrors_",files[i],sep=""))
    checklist[i,"variable.regex.checks"] <- FALSE
  }
}

print(checklist)
write.table(checklist,paste(output.dir,"checklist.txt",sep="/"))
