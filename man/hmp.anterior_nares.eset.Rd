\name{ hmp.anterior_nares.eset }
\alias{ hmp.anterior_nares.marker_ab.eset }
\alias{ hmp.anterior_nares.marker_pres.eset }
\alias{ hmp.anterior_nares.abundance.eset }
\alias{ hmp.anterior_nares.pathCov.eset }
\alias{ hmp.anterior_nares.pathAbun.eset }
\alias{ hmp.anterior_nares.geneFam.eset }
\docType{data}
\title{ Structure, function and diversity of the healthy human microbiome }
\description{ Studies of the human microbiome have revealed that even healthy individuals differ remarkably in the microbes that occupy habitats such as the gut, skin and vagina. Much of this diversity remains unexplained, although diet, environment, host genetics and early microbial exposure have all been implicated. Accordingly, to characterize the ecology of human-associated microbial communities, the Human Microbiome Project has analysed the largest cohort and set of distinct, clinically relevant body habitats so far. We found the diversity and abundance of each habitat's signature microbes to vary widely even among healthy subjects, with strong niche specialization both within and among individuals. The project encountered an estimated 81-99\% of the genera, enzyme families and community configurations occupied by the healthy Western microbiome. Metagenomic carriage of metabolic pathways was stable among individuals despite variation in community structure, and ethnic/racial background proved to be one of the strongest associations of both pathways and microbes with clinical metadata. These results thus delineate the range of structural and functional configurations normal in the microbial communities of a healthy population, enabling future characterization of the epidemiology, ecology and translational applications of the human microbiome. }
\usage{data( hmp.anterior_nares.marker_ab.eset )}
\format{
\preformatted{
experimentData(eset):
Experiment data
  Experimenter name: Huttenhower C, Gevers D, Knight R et al. 
  Laboratory: Human Microbiome Project Consortium 
  Contact information:  
  Title: Structure, function and diversity of the healthy human microbiome 
  URL:  
  PMIDs: 22699609 

  Abstract: A 187 word abstract is available. Use 'abstract' method.
  notes:
   platform_summary:     
      NA
   platform_accession:     
      NA
   platform_title:     
      GAIIx
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
assayData: 302989 features, 94 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
hmp 
 94 

sampleID: 
   Length     Class      Mode 
       94 character character 

subjectID: 
   Length     Class      Mode 
       94 character character 

bodysite: 
anterior_nares 
            94 

disease: 
 n 
94 

gender: 
female   male 
    36     58 

country: 
usa 
 94 

sequencing_technology: 
Illumina 
      94 

pubmedid: 
22699609 
      94 

X.SampleID: 
Metaphlan2_Analysis 
                 94 

visit_number: 
 1  2  3 
61 32  1 

snprnt: 
   Length     Class      Mode 
       94 character character 

wmsphase: 
 1 
94 

}}
\keyword{datasets}
