\name{ Chatelier_gut_obesity.stool.eset }
\alias{ Chatelier_gut_obesity.stool.marker_ab.eset }
\alias{ Chatelier_gut_obesity.stool.marker_pres.eset }
\alias{ Chatelier_gut_obesity.stool.abundance.eset }
\alias{ Chatelier_gut_obesity.stool.pathCov.eset }
\alias{ Chatelier_gut_obesity.stool.pathAbun.eset }
\alias{ Chatelier_gut_obesity.stool.geneFam.eset }
\docType{data}
\title{ Richness of human gut microbiome correlates with metabolic markers }
\description{ We are facing a global metabolic health crisis provoked by an obesity epidemic. Here we report the human gut microbial composition in a population sample of 123 non-obese and 169 obese Danish individuals. We find two groups of individuals that differ by the number of gut microbial genes and thus gut bacterial richness. They contain known and previously unknown bacterial species at different proportions; individuals with a low bacterial richness (23\% of the population) are characterized by more marked overall adiposity, insulin resistance and dyslipidaemia and a more pronounced inflammatory phenotype when compared with high bacterial richness individuals. The obese individuals among the lower bacterial richness group also gain more weight over time. Only a few bacterial species are sufficient to distinguish between individuals with high and low bacterial richness, and even between lean and obese participants. Our classifications based on variation in the gut microbiome identify subsets of individuals in the general white adult population who may be at increased risk of progressing to adiposity-associated co-morbidities. }
\usage{Chatelier_gut_obesity.stool.marker_ab.eset(metadata=FALSE)}
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
  Experimenter name: Le Chatelier E, Nielsen T, Qin J, Prifti E, Hildebrand F, Falony G, Almeida M, Arumugam M, Batto JM, Kennedy S, Leonard P, Li J, Burgdorf K, Grarup N, J??rgensen T, Brandslund I, Nielsen HB, Juncker AS, Bertalan M, Levenez F, Pons N, Rasmussen S, Sunagawa S, Tap J, Tims S, Zoetendal EG, Brunak S, Cl??ment K, Dor?? J, Kleerebezem M, Kristiansen K, Renault P, Sicheritz-Ponten T, de Vos WM, Zucker JD, Raes J, Hansen T, Bork P, Wang J, Ehrlich SD, Pedersen O 
  Laboratory: INRA, Institut National de la Recherche Agronomique, US1367 Metagenopolis, 78350 Jouy en Josas, France. 
  Contact information:  
  Title: Richness of human gut microbiome correlates with metabolic markers 
  URL:  
  PMIDs: 23985870 

  Abstract: A 167 word abstract is available. Use 'abstract' method.
  notes:
   platform_summary:     
      NA
   platform_accession:     
      NA
   platform_title:     
       Genome Analyzer II
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
assayData: 302989 features, 278 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
Chatelier_gut_obesity 
                  278 

sampleID: 
   Length     Class      Mode 
      278 character character 

subjectID: 
   Length     Class      Mode 
      278 character character 

bodysite: 
stool 
  278 

disease: 
leaness       n obesity 
     89      25     164 

country: 
denmark 
    278 

sequencing_technology: 
Illumina 
     278 

pubmedid: 
23985870 
     278 

paired_end_insert_size: 
   Length     Class      Mode 
      278 character character 

read_length: 
44/75    75    90 
    1   162   115 

total_reads: 
   Length     Class      Mode 
      278 character character 

matched_reads: 
   Length     Class      Mode 
      278 character character 

uniquely_matching_reads: 
   Length     Class      Mode 
      278 character character 

uniquely_matched_reads: 
   Length     Class      Mode 
      278 character character 

gene_number: 
   Length     Class      Mode 
      278 character character 

gene_number_for_11m_uniquely_matched_reads: 
   Length     Class      Mode 
      278 character character 

hitchip_probe_number: 
   Length     Class      Mode 
      278 character character 

bmi: 
   Length     Class      Mode 
      278 character character 

gene_count_class: 
hgc lgc 
212  66 

hitchip_probe_class: 
hpc lpc 
221  57 

X.SampleID: 
Metaphlan2_Analysis 
                278 

}}
\keyword{datasets}
