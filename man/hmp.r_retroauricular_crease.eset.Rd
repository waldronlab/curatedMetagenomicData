\name{ hmp.r_retroauricular_crease.eset }
\alias{ hmp.r_retroauricular_crease.marker_ab.eset }
\alias{ hmp.r_retroauricular_crease.marker_pres.eset }
\alias{ hmp.r_retroauricular_crease.abundance.eset }
\alias{ hmp.r_retroauricular_crease.pathCov.eset }
\alias{ hmp.r_retroauricular_crease.pathAbun.eset }
\alias{ hmp.r_retroauricular_crease.geneFam.eset }
\docType{data}
\title{ Structure, function and diversity of the healthy human microbiome }
\description{ Studies of the human microbiome have revealed that even healthy individuals differ remarkably in the microbes that occupy habitats such as the gut, skin and vagina. Much of this diversity remains unexplained, although diet, environment, host genetics and early microbial exposure have all been implicated. Accordingly, to characterize the ecology of human-associated microbial communities, the Human Microbiome Project has analysed the largest cohort and set of distinct, clinically relevant body habitats so far. We found the diversity and abundance of each habitat's signature microbes to vary widely even among healthy subjects, with strong niche specialization both within and among individuals. The project encountered an estimated 81-99\% of the genera, enzyme families and community configurations occupied by the healthy Western microbiome. Metagenomic carriage of metabolic pathways was stable among individuals despite variation in community structure, and ethnic/racial background proved to be one of the strongest associations of both pathways and microbes with clinical metadata. These results thus delineate the range of structural and functional configurations normal in the microbial communities of a healthy population, enabling future characterization of the epidemiology, ecology and translational applications of the human microbiome. }
\usage{hmp.r_retroauricular_crease.marker_ab.eset(metadata=FALSE)}
\arguments{
  \item{metadata}{
    \code{logical} value indicating whether the resource should be loaded
    (metadata=FALSE) or if metadata only should be returned.
  }
}
\format{
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
assayData: 302989 features, 18 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
hmp 
 18 

sampleID: 
   Length     Class      Mode 
       18 character character 

subjectID: 
   Length     Class      Mode 
       18 character character 

bodysite: 
r_retroauricular_crease 
                     18 

disease: 
 n 
18 

gender: 
female   male 
     2     16 

country: 
usa 
 18 

sequencing_technology: 
Illumina 
      18 

pubmedid: 
22699609 
      18 

X.SampleID: 
Metaphlan2_Analysis 
                 18 

visit_number: 
 1  2 
 6 12 

snprnt: 
   Length     Class      Mode 
       18 character character 

wmsphase: 
 1 
18 

}}
\keyword{datasets}
