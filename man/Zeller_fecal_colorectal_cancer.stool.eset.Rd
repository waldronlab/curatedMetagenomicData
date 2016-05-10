\name{ Zeller_fecal_colorectal_cancer.stool.eset }
\alias{ Zeller_fecal_colorectal_cancer.stool.marker_ab.eset }
\alias{ Zeller_fecal_colorectal_cancer.stool.marker_pres.eset }
\alias{ Zeller_fecal_colorectal_cancer.stool.abundance.eset }
\alias{ Zeller_fecal_colorectal_cancer.stool.pathCov.eset }
\alias{ Zeller_fecal_colorectal_cancer.stool.pathAbun.eset }
\alias{ Zeller_fecal_colorectal_cancer.stool.geneFam.eset }
\docType{data}
\title{ Potential of fecal microbiota for early-stage detection of colorectal cancer }
\description{ Several bacterial species have been implicated in the development of colorectal carcinoma (CRC), but CRC-associated changes of fecal microbiota and their potential for cancer screening remain to be explored. Here, we used metagenomic sequencing of fecal samples to identify taxonomic markers that distinguished CRC patients from tumor-free controls in a study population of 156 participants. Accuracy of metagenomic CRC detection was similar to the standard fecal occult blood test (FOBT) and when both approaches were combined, sensitivity improved > 45\% relative to the FOBT, while maintaining its specificity. Accuracy of metagenomic CRC detection did not differ significantly between early- and late-stage cancer and could be validated in independent patient and control populations (N = 335) from different countries. CRC-associated changes in the fecal microbiome at least partially reflected microbial community composition at the tumor itself, indicating that observed gene pool differences may reveal tumor-related host-microbe interactions. Indeed, we deduced a metabolic shift from fiber degradation in controls to utilization of host carbohydrates and amino acids in CRC patients, accompanied by an increase of lipopolysaccharide metabolism. }
\usage{data( Zeller_fecal_colorectal_cancer.stool.marker_ab.eset )}
\format{
\preformatted{
experimentData(eset):
Experiment data
  Experimenter name: Zeller G, Tap J, Voigt AY, Sunagawa S, Kultima JR, Costea PI, Amiot A, B??hm J, Brunetti F, Habermann N, Hercog R, Koch M, Luciani A, Mende DR, Schneider MA, Schrotz-King P, Tournigand C, Tran Van Nhieu J, Yamada T, Zimmermann J, Benes V, Kloor M, Ulrich CM, von Knebel Doeberitz M, Sobhani I, Bork P 
  Laboratory: Structural and Computational Biology Unit, European Molecular Biology Laboratory, Heidelberg, Germany. 
  Contact information:  
  Title: Potential of fecal microbiota for early-stage detection of colorectal cancer 
  URL:  
  PMIDs: 25432777 

  Abstract: A 175 word abstract is available. Use 'abstract' method.
  notes:
   platform_summary:     
      NA
   platform_accession:     
      NA
   platform_title:     
      HiSeq 2000/2500
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
assayData: 302989 features, 134 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
Zeller_fecal_colorectal_cancer 
                           134 

sampleID: 
   Length     Class      Mode 
      134 character character 

subjectID: 
   Length     Class      Mode 
      134 character character 

bodysite: 
stool 
  134 

disease: 
       cancer large_adenoma             n small_adenoma 
           48            13            47            26 

age: 
   Length     Class      Mode 
      134 character character 

gender: 
female   male 
    59     75 

country: 
france 
   134 

sequencing_technology: 
Illumina 
     134 

pubmedid: 
25432777 
     134 

bmi: 
   Length     Class      Mode 
      134 character character 

X.SampleID: 
Metaphlan2_Analysis 
                134 

tnm_stage: 
   Length     Class      Mode 
      134 character character 

ajcc_stage: 
  i  ii iii  iv  na 
 15   6   8  19  86 

localization: 
   Length     Class      Mode 
      134 character character 

fobt: 
negative positive 
     102       32 

wif.1_gene_methylation_test: 
      na negative positive 
       4      104       26 

group: 
control     crc      na 
     73      48      13 

}}
\keyword{datasets}
