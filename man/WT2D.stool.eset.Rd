\name{ WT2D.stool.eset }
\alias{ WT2D.stool.marker_ab.eset }
\alias{ WT2D.stool.marker_pres.eset }
\alias{ WT2D.stool.abundance.eset }
\alias{ WT2D.stool.pathCov.eset }
\alias{ WT2D.stool.pathAbun.eset }
\alias{ WT2D.stool.geneFam.eset }
\docType{data}
\title{ Gut metagenome in European women with normal, impaired and diabetic glucose control }
\description{ Type 2 diabetes (T2D) is a result of complex gene-environment interactions, and several risk factors have been identified, including age, family history, diet, sedentary lifestyle and obesity. Statistical models that combine known risk factors for T2D can partly identify individuals at high risk of developing the disease. However, these studies have so far indicated that human genetics contributes little to the models, whereas socio-demographic and environmental factors have greater influence. Recent evidence suggests the importance of the gut microbiota as an environmental factor, and an altered gut microbiota has been linked to metabolic diseases including obesity, diabetes and cardiovascular disease. Here we use shotgun sequencing to characterize the faecal metagenome of 145 European women with normal, impaired or diabetic glucose control. We observe compositional and functional alterations in the metagenomes of women with T2D, and develop a mathematical model based on metagenomic profiles that identified T2D with high accuracy. We applied this model to women with impaired glucose tolerance, and show that it can identify women who have a diabetes-like metabolism. Furthermore, glucose control and medication were unlikely to have major confounding effects. We also applied our model to a recently described Chinese cohort and show that the discriminant metagenomic markers for T2D differ between the European and Chinese cohorts. Therefore, metagenomic predictive tools for T2D should be specific for the age and geographical location of the populations studied. }
\usage{WT2D.stool.marker_ab.eset(metadata=FALSE)}
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
  Experimenter name: Karlsson FH, Tremaroli V, Nookaew I, Bergstr??m G, Behre CJ, Fagerberg B, Nielsen J, B??ckhed F 
  Laboratory: Department of Chemical and Biological Engineering, Chalmers University of Technology, SE-412 96 Gothenburg, Sweden. 
  Contact information:  
  Title: Gut metagenome in European women with normal, impaired and diabetic glucose control 
  URL:  
  PMIDs: 23719380 

  Abstract: A 229 word abstract is available. Use 'abstract' method.
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
assayData: 302989 features, 145 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
WT2D 
 145 

sampleID: 
   Length     Class      Mode 
      145 character character 

subjectID: 
   Length     Class      Mode 
      145 character character 

bodysite: 
stool 
  145 

disease: 
impaired_glucose_tolerance                          n                        t2d 
                        49                         43                         53 

age: 
   Length     Class      Mode 
      145 character character 

country: 
   Length     Class      Mode 
      145 character character 

sequencing_technology: 
Illumina 
     145 

pubmedid: 
23719380 
     145 

bmi: 
   Length     Class      Mode 
      145 character character 

X.SampleID: 
Metaphlan2_Analysis 
                145 

hdl: 
   Length     Class      Mode 
      145 character character 

ldl: 
   Length     Class      Mode 
      145 character character 

classification: 
igt ngt t2d 
 49  43  53 

gad.antibodies: 
   Length     Class      Mode 
      145 character character 

whr: 
   Length     Class      Mode 
      145 character character 

wc: 
   Length     Class      Mode 
      145 character character 

cholesterol: 
   Length     Class      Mode 
      145 character character 

triglycerides: 
   Length     Class      Mode 
      145 character character 

creatinine: 
   Length     Class      Mode 
      145 character character 

y.gt: 
   Length     Class      Mode 
      145 character character 

fasting_glucose: 
   Length     Class      Mode 
      145 character character 

fasting_insulin: 
   Length     Class      Mode 
      145 character character 

hba1c: 
   Length     Class      Mode 
      145 character character 

adiponectin: 
   Length     Class      Mode 
      145 character character 

leptin: 
   Length     Class      Mode 
      145 character character 

glp.1: 
   Length     Class      Mode 
      145 character character 

fgf.19: 
   Length     Class      Mode 
      145 character character 

hscrp: 
   Length     Class      Mode 
      145 character character 

c.peptide: 
   Length     Class      Mode 
      145 character character 

tnfa: 
   Length     Class      Mode 
      145 character character 

il.1: 
   Length     Class      Mode 
      145 character character 

cd163: 
   Length     Class      Mode 
      145 character character 

statins: 
 n  y 
93 52 

insulin: 
  n   y 
139   6 

oral_anti.diabetic_medication: 
  met sulph  NA's 
   20     2   123 

years_in_sweden: 
   Length     Class      Mode 
      145 character character 

}}
\keyword{datasets}
