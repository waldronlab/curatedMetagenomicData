#install.packages("devtools")
library(devtools)
#install_github("lwaldron/LeviRmisc")
library(LeviRmisc)
#install.packages("annotate")

#biocLite("annotate")
library("annotate")

# Script to Populate Experiment-Data slots by using annotate::PMIDlookup and annotate::getPMInfo functions.

annotateEsets <- function(pmidFile = './Experiment_Data.txt', baseDir ="./Chatelier_esets",
                          outDir = "./annotated_Chatelier_esets"){

  anno_pmid <- read.table(file=pmidFile, header=T, sep='\t', stringsAsFactors=F)

  #baseDir <- "./abundance_subesets"
  #outDir <- "./abundance_Annotated.subesets"

  rdaFiles <- list.files(baseDir, pattern = "*rda", full.names=F)

  for (n in 1:length(rdaFiles)){
    esetFile <- rdaFiles[n]
    print(paste("working on --- : ", esetFile))
    eset <- get(load(paste(baseDir, esetFile, sep ='/')))
    #eset <- get(eset)

    name <- strsplit(esetFile, "\\.")[[1]][1]

    idx <- grep(name, anno_pmid$study, ignore.case = T)
    if (length(idx) > 1){
      idx <- idx[1]
    }
    study <- anno_pmid$study[idx]
    pmid <- anno_pmid$PMID[idx]
    sequencer <- anno_pmid$sequencer[idx]
    technology <- anno_pmid$technology[idx]
    manufacturer <- anno_pmid$technology[idx]
    processor <- "MetaPhlAn2 (marker & abundance) / HUMAnN2 (geneFam., pathAbun., & pathCov.)"
    laboratory <- anno_pmid$Laboratory[idx]

    abstract <- "-"
    if (length(pmid) == 0 || pmid == "-"){
      pmid_info <- data.frame(matrix(NA, nrow=2, ncol=19,
                                     dimnames=list(rownames=NULL,
                                                   colnames=c("pubMedIds", "platform_accession", "platform_summary",
                                                              "platform_title" , "platform_technology", "platform_distribution",
                                                              "platform_manufacturer" ,"series_title", "series_summary",
                                                              "series_overall_design", "series_contributor", "authors" ,
                                                              "year" , "title" ,  "journal" ,                                                                  "volume" , "pages", "pubdate" ,
                                                              "artdate" ))))
      rownames(pmid_info) <- c(name, "PMID1234")
    }else{
      ##use geoPmidLookUp to get anotation info. from pubmed ID
      pmidid <- paste("PMID", pmid, sep='')
      pmid_info <- geoPmidLookup(c(pmidid, "PMID1234"))
      #pmid_info <- geoPmidLookup(c(paste("PMID", pmid, sep=''), "PMID1234"))
      rownames(pmid_info) <- c(name, "PMID1234")
      ## create a function to replace '%' in a string with '\\%', and convert non-ASCII text to "?"
      abstract <- annotate::getPMInfo(pubmed(pmid))[[1]][[3]]
      abstract <- gsub("%", "\\%", iconv(abstract, "latin1", "ASCII", sub="?"), fixed=TRUE)
    }
    ## create a dataframe containing annotation info
    experiment.info <- data.frame(matrix(NA, nrow=1, ncol=6,
                                         dimnames=list(rownames=NULL,
                                                       colnames=c("pubMedIds", "title", "name", "citation",
                                                                  "platform_summary", "platform_accession"))))
    rownames(experiment.info) <- name

    #populate experiment.info with information from geoPmidLookup
    for (id in rownames(experiment.info)){
      for (iName in colnames(pmid_info)){
        if(is.null(experiment.info[id, iName]) || is.na(experiment.info[id, iName]))
          experiment.info[id, iName] <- pmid_info[id, iName]
      }}

    experiment.info <- experiment.info[match(name,rownames(experiment.info)),]

    ##Convert to ASCII:
    for (i in 1:ncol(experiment.info)){
      if(is(experiment.info[, i], "character"))
        experiment.info[, i] <- iconv(experiment.info[, i], "latin1", "ASCII", sub="?")
    }

    ## For each eset, add info to annoation slots
    i <- 1
    experiment.miame <- new("MIAME")
    experiment.miame@pubMedIds <- as.character(experiment.info[i,"pubMedIds"])
    experiment.miame@title <- as.character(experiment.info[i,"title"])
    #experiment.miame@abstract <- paste("abstract ", (as.character(experiment.info[i,"citation"])), sep="")
    experiment.miame@abstract <- abstract

    #experiment.miame@name <- as.character(experiment.info[i,"citation"])  ##over-write default
    #experiment.miame@preprocessing <- list(phenoProcessingMethod[i])
    #experiment.miame@lab <- as.character(experiment.info[i,"name"])
    if (length(study) != 0 && study == "hmp"){
      experiment.miame@name <- "Huttenhower C, Gevers D, Knight R et al."
    }else{
      experiment.miame@name <- as.character(experiment.info[i,"authors"])
    }
    experiment.miame@lab <- laboratory


    eset@annotation <- as.character(experiment.info[i,"platform_summary"])
    experiment.miame@other <- as.list(experiment.info[i, grepl("platform", colnames(experiment.info))])
    experimentData(eset) <- experiment.miame
    experimentData(eset)@other$platform_technology <- technology
    experimentData(eset)@other$platform_title <- sequencer
    experimentData(eset)@other$platform_manufacturer <- manufacturer
    experimentData(eset)@other$processor <- processor

    esetObjectout<-sub(".rda","",esetFile,  ignore.case = T)

    esetFileout<-sub("rda","rda",esetFile)
    assign(esetObjectout, eset)
    dir.create(outDir)
    save(list = esetObjectout, file=paste(outDir, esetFileout, sep="/"))

  }
}
annotateEsets(pmidFile = './Experiment_Data.txt', baseDir ="./Chatelier_esets",
              outDir = "./annotated_Chatelier_esets")
