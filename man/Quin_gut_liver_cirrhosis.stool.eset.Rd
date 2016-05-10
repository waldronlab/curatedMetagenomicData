\name{ Quin_gut_liver_cirrhosis.stool.eset }
\alias{ Quin_gut_liver_cirrhosis.stool.marker_ab.eset }
\alias{ Quin_gut_liver_cirrhosis.stool.marker_pres.eset }
\alias{ Quin_gut_liver_cirrhosis.stool.abundance.eset }
\alias{ Quin_gut_liver_cirrhosis.stool.pathCov.eset }
\alias{ Quin_gut_liver_cirrhosis.stool.pathAbun.eset }
\alias{ Quin_gut_liver_cirrhosis.stool.geneFam.eset }
\docType{data}
\title{ Alterations of the human gut microbiome in liver cirrhosis }
\description{ Liver cirrhosis occurs as a consequence of many chronic liver diseases that are prevalent worldwide. Here we characterize the gut microbiome in liver cirrhosis by comparing 98 patients and 83 healthy control individuals. We build a reference gene set for the cohort containing 2.69??million genes, 36.1\% of which are novel. Quantitative metagenomics reveals 75,245 genes that differ in abundance between the patients and healthy individuals (false discovery rate??<??0.0001) and can be grouped into 66 clusters representing cognate bacterial species; 28 are enriched in patients and 38 in control individuals. Most (54\%) of the patient-enriched, taxonomically assigned species are of buccal origin, suggesting an invasion of the gut from the mouth in liver cirrhosis. Biomarkers specific to liver cirrhosis at gene and function levels are revealed by a comparison with those for type 2 diabetes and inflammatory bowel disease. On the basis of only 15 biomarkers, a highly accurate patient discrimination index is created and validated on an independent cohort. Thus microbiota-targeted biomarkers may be a powerful tool for diagnosis of different diseases. }
\usage{data( Quin_gut_liver_cirrhosis.stool.marker_ab.eset )}
\format{
\preformatted{
experimentData(eset):
Experiment data
  Experimenter name: Qin N, Yang F, Li A, Prifti E, Chen Y, Shao L, Guo J, Le Chatelier E, Yao J, Wu L, Zhou J, Ni S, Liu L, Pons N, Batto JM, Kennedy SP, Leonard P, Yuan C, Ding W, Chen Y, Hu X, Zheng B, Qian G, Xu W, Ehrlich SD, Zheng S, Li L 
  Laboratory: 1] State Key Laboratory for Diagnosis and Treatment of Infectious Disease, The First Affiliated Hospital, College of Medicine, Zhejiang University, 310003 Hangzhou, China [2] Collaborative Innovation Center for Diagnosis and Treatment of Infectious Diseases, Zhejiang University, 310003 Hangzhou, China [3]. 
  Contact information:  
  Title: Alterations of the human gut microbiome in liver cirrhosis 
  URL:  
  PMIDs: 25079328 

  Abstract: A 172 word abstract is available. Use 'abstract' method.
  notes:
   platform_summary:     
      NA
   platform_accession:     
      NA
   platform_title:     
      HiSeq 2000
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
assayData: 302989 features, 232 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
Quin_gut_liver_cirrhosis 
                     232 

sampleID: 
   Length     Class      Mode 
      232 character character 

subjectID: 
   Length     Class      Mode 
      232 character character 

bodysite: 
stool 
  232 

disease: 
cirrhosis         n 
      118       114 

age: 
   Length     Class      Mode 
      232 character character 

gender: 
female   male 
    80    152 

country: 
china 
  232 

sequencing_technology: 
Illumina 
     232 

pubmedid: 
25079328 
     232 

bmi: 
   Length     Class      Mode 
      232 character character 

X.SampleID: 
Metaphlan2_Analysis 
                232 

stage: 
 discovery validation 
       178         54 

cirrhotic: 
  n   y 
114 118 

hbv_related: 
  n   y 
135  97 

alcohol_related: 
  n   y 
200  32 

other_causes_related: 
   Length     Class      Mode 
      232 character character 

inr: 
   Length     Class      Mode 
      232 character character 

crea: 
   Length     Class      Mode 
      232 character character 

alb: 
   Length     Class      Mode 
      232 character character 

tb: 
   Length     Class      Mode 
      232 character character 

pt: 
   Length     Class      Mode 
      232 character character 

ascites: 
absent   mild  sever   NA's 
    54     36     28    114 

he: 
grade_1    none    NA's 
      2     116     114 

ctp: 
   Length     Class      Mode 
      232 character character 

meld: 
   Length     Class      Mode 
      232 character character 

antivirus: 
   Length     Class      Mode 
      232 character character 

X..blocker: 
       none propranolol        NA's 
        106          12         114 

}}
\keyword{datasets}
