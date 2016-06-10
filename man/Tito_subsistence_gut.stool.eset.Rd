\name{ Tito_subsistence_gut.stool.eset }
\alias{ Tito_subsistence_gut.stool.marker_ab.eset }
\alias{ Tito_subsistence_gut.stool.marker_pres.eset }
\alias{ Tito_subsistence_gut.stool.abundance.eset }
\alias{ Tito_subsistence_gut.stool.pathCov.eset }
\alias{ Tito_subsistence_gut.stool.pathAbun.eset }
\alias{ Tito_subsistence_gut.stool.geneFam.eset }
\docType{data}
\title{ Subsistence strategies in traditional societies distinguish gut microbiomes }
\description{ Recent studies suggest that gut microbiomes of urban-industrialized societies are different from those of traditional peoples. Here we examine the relationship between lifeways and gut microbiota through taxonomic and functional potential characterization of faecal samples from hunter-gatherer and traditional agriculturalist communities in Peru and an urban-industrialized community from the US. We find that in addition to taxonomic and metabolic differences between urban and traditional lifestyles, hunter-gatherers form a distinct sub-group among traditional peoples. As observed in previous studies, we find that Treponema are characteristic of traditional gut microbiomes. Moreover, through genome reconstruction (2.2-2.5???MB, coverage depth ?? 26-513) and functional potential characterization, we discover these Treponema are diverse, fall outside of pathogenic clades and are similar to Treponema succinifaciens, a known carbohydrate metabolizer in swine. Gut Treponema are found in non-human primates and all traditional peoples studied to date, suggesting they are symbionts lost in urban-industrialized societies. }
\usage{Tito_subsistence_gut.stool.marker_ab.eset(metadata=FALSE)}
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
  Experimenter name: Obregon-Tito AJ, Tito RY, Metcalf J, Sankaranarayanan K, Clemente JC, Ursell LK, Zech Xu Z, Van Treuren W, Knight R, Gaffney PM, Spicer P, Lawson P, Marin-Reyes L, Trujillo-Villarroel O, Foster M, Guija-Poma E, Troncoso-Corzo L, Warinner C, Ozga AT, Lewis CM 
  Laboratory: 1] Department of Anthropology, University of Oklahoma, Dale Hall Tower, 521  Norman, Oklahoma 73019, USA [2] Universidad Cientifica del Sur, Lima 18, Peru [3]    City of Hope, NCI-designated Comprehensive Cancer Center, Duarte, California 91010, USA 
  Contact information:  
  Title: Subsistence strategies in traditional societies distinguish gut microbiomes 
  URL:  
  PMIDs: 25807110 

  Abstract: A 146 word abstract is available. Use 'abstract' method.
  notes:
   platform_summary:     
      NA
   platform_accession:     
      NA
   platform_title:     
      Illumina
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
assayData: 302989 features, 58 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
Tito_subsistence_gut 
                  58 

sampleID: 
   Length     Class      Mode 
       58 character character 

subjectID: 
   Length     Class      Mode 
       58 character character 

bodysite: 
stool 
   58 

disease: 
          n       obese  overweight underweight        NA's 
         35           5          10           1           7 

age: 
   Length     Class      Mode 
       58 character character 

gender: 
female   male     na 
    30     27      1 

country: 
peru  usa 
  36   22 

sequencing_technology: 
Illumina 
      58 

pubmedid: 
25807110 
      58 

bmi: 
   Length     Class      Mode 
       58 character character 

X.SampleID: 
Metaphlan2_Analysis 
                 58 

ethnicity: 
unknown   white 
     36      22 

population: 
  matses   norman tunapuco 
      24       22       12 

bmi_class: 
    healthy          na       obese  overweight underweight 
         35           7           5          10           1 

X16s_rrna: 
yes 
 58 

shotgun_metagenome: 
yes 
 58 

read_depth_16s: 
   Length     Class      Mode 
       58 character character 

paired: 
   Length     Class      Mode 
       58 character character 

single: 
   Length     Class      Mode 
       58 character character 

}}
\keyword{datasets}
