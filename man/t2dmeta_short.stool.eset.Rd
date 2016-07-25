\name{ t2dmeta_short.stool.eset }
\alias{ t2dmeta_short.stool.marker_ab.eset }
\alias{ t2dmeta_short.stool.marker_pres.eset }
\alias{ t2dmeta_short.stool.abundance.eset }
\alias{ t2dmeta_short.stool.pathCov.eset }
\alias{ t2dmeta_short.stool.pathAbun.eset }
\alias{ t2dmeta_short.stool.geneFam.eset }
\docType{data}
\title{ A metagenome-wide association study of gut microbiota in type 2 diabetes }
\description{ Assessment and characterization of gut microbiota has become a major research area in human disease, including type 2 diabetes, the most prevalent endocrine disease worldwide. To carry out analysis on gut microbial content in patients with type 2 diabetes, we developed a protocol for a metagenome-wide association study (MGWAS) and undertook a two-stage MGWAS based on deep shotgun sequencing of the gut microbial DNA from 345 Chinese individuals. We identified and validated approximately 60,000 type-2-diabetes-associated markers and established the concept of a metagenomic linkage group, enabling taxonomic species-level analyses. MGWAS analysis showed that patients with type 2 diabetes were characterized by a moderate degree of gut microbial dysbiosis, a decrease in the abundance of some universal butyrate-producing bacteria and an increase in various opportunistic pathogens, as well as an enrichment of other microbial functions conferring sulphate reduction and oxidative stress resistance. An analysis of 23 additional individuals demonstrated that these gut microbial markers might be useful for classifying type 2 diabetes. }
\usage{t2dmeta_short.stool.marker_ab.eset(metadata=FALSE)}
\arguments{
  \item{metadata}{
    \code{logical} value indicating whether metadata only should be returned
    or if the resource should be loaded. Default behavior(metadata=FALSE) 
    loads the data.
  }
}
\format{
\preformatted{
experimentData(eset):
Experiment data
  Experimenter name: Qin J, Li Y, Cai Z, Li S, Zhu J, Zhang F, Liang S, Zhang W, Guan Y, Shen D, Peng Y, Zhang D, Jie Z, Wu W, Qin Y, Xue W, Li J, Han L, Lu D, Wu P, Dai Y, Sun X, Li Z, Tang A, Zhong S, Li X, Chen W, Xu R, Wang M, Feng Q, Gong M, Yu J, Zhang Y, Zhang M, Hansen T, Sanchez G, Raes J, Falony G, Okuda S, Almeida M, LeChatelier E, Renault P, Pons N, Batto JM, Zhang Z, Chen H, Yang R, Zheng W, Li S, Yang H, Wang J, Ehrlich SD, Nielsen R, Pedersen O, Kristiansen K, Wang J 
  Laboratory: BGI-Shenzhen, Shenzhen 518083, China. 
  Contact information:  
  Title: A metagenome-wide association study of gut microbiota in type 2 diabetes 
  URL:  
  PMIDs: 23023125 

  Abstract: A 161 word abstract is available. Use 'abstract' method.
  notes:
   platform_summary:     
      NA
   platform_accession:     
      NA
   platform_title:     
      GAIIx and HiSeq 2000
   platform_technology:     
      Illumina
   platform_distribution:     
      NA
   platform_manufacturer:     
      Illumina
   processor:     
      MetaPhlAn2 (marker & abundance) / HUMAnN2 (geneFam., pathAbun., & pathCov.)

featureData(eset):
An object of class 'AnnotatedDataFrame': none

}}
\details{
\preformatted{
assayData: 302989 features, 73 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
t2dmeta_short 
           73 

sampleID: 
   Length     Class      Mode 
       73 character character 

subjectID: 
   Length     Class      Mode 
       73 character character 

bodysite: 
stool 
   73 

disease: 
  n t2d 
 38  35 

age: 
   Length     Class      Mode 
       73 character character 

gender: 
female   male 
    35     38 

country: 
china 
   73 

sequencing_technology: 
Illumina 
      73 

pubmedid: 
23023125 
      73 

bmi: 
   Length     Class      Mode 
       73 character character 

X.SampleID: 
Metaphlan2_Analysis 
                 73 

stage: 
stage_i 
     73 

height: 
   Length     Class      Mode 
       73 character character 

weight: 
   Length     Class      Mode 
       73 character character 

diabetic: 
 n  y 
38 35 

fbg: 
   Length     Class      Mode 
       73 character character 

sbp: 
   Length     Class      Mode 
       73 character character 

dbp: 
   Length     Class      Mode 
       73 character character 

fins: 
   Length     Class      Mode 
       73 character character 

hbalc: 
   Length     Class      Mode 
       73 character character 

tg: 
   Length     Class      Mode 
       73 character character 

tcho: 
   Length     Class      Mode 
       73 character character 

hdl: 
   Length     Class      Mode 
       73 character character 

ldl: 
   Length     Class      Mode 
       73 character character 

}}
\keyword{datasets}
