## -----------------------------------------------------------------------------
## Logging setup
## -----------------------------------------------------------------------------

if (!exists("package.name")) package.name <- "curatedMetagenomicData"
library(package.name, character.only=TRUE)

## -----------------------------------------------------------------------------
##load the esets
## -----------------------------------------------------------------------------
data(list=data(package=package.name)[[3]][,3])
strEsets <- ls(pattern="eset$")
select.datasets <- strEsets
esets <- list()

if(!is.na(bodysite)){
  select.datasets <- grep(bodysite, select.datasets, value=TRUE)
}

if(!is.na(study)){
  select.datasets <- grep(study, select.datasets, value=TRUE)
}

for (strEset in strEsets){
  if(strEset %in% select.datasets){
    eset <- get(strEset)
    esets[[strEset]] <- eset
    rm(eset)
  }
}
