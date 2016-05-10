\name{ Neilsen_genome_assembly.stool.eset }
\alias{ Neilsen_genome_assembly.stool.marker_ab.eset }
\alias{ Neilsen_genome_assembly.stool.marker_pres.eset }
\alias{ Neilsen_genome_assembly.stool.abundance.eset }
\alias{ Neilsen_genome_assembly.stool.pathCov.eset }
\alias{ Neilsen_genome_assembly.stool.pathAbun.eset }
\alias{ Neilsen_genome_assembly.stool.geneFam.eset }
\docType{data}
\title{ Identification and assembly of genomes and genetic elements in complex metagenomic samples without using reference genomes }
\description{ Most current approaches for analyzing metagenomic data rely on comparisons to reference genomes, but the microbial diversity of many environments extends far beyond what is covered by reference databases. De novo segregation of complex metagenomic data into specific biological entities, such as particular bacterial strains or viruses, remains a largely unsolved problem. Here we present a method, based on binning co-abundant genes across a series of metagenomic samples, that enables comprehensive discovery of new microbial organisms, viruses and co-inherited genetic entities and aids assembly of microbial genomes without the need for reference sequences. We demonstrate the method on data from 396 human gut microbiome samples and identify 7,381 co-abundance gene groups (CAGs), including 741 metagenomic species (MGS). We use these to assemble 238 high-quality microbial genomes and identify affiliations between MGS and hundreds of viruses or genetic entities. Our method provides the means for comprehensive profiling of the diversity within complex metagenomic samples. }
\usage{data( Neilsen_genome_assembly.stool.marker_ab.eset )}
\format{
\preformatted{
experimentData(eset):
Experiment data
  Experimenter name: Nielsen HB, Almeida M, Juncker AS, Rasmussen S, Li J, Sunagawa S, Plichta DR, Gautier L, Pedersen AG, Le Chatelier E, Pelletier E, Bonde I, Nielsen T, Manichanh C, Arumugam M, Batto JM, Quintanilha Dos Santos MB, Blom N, Borruel N, Burgdorf KS, Boumezbeur F, Casellas F, Dor?? J, Dworzynski P, Guarner F, Hansen T, Hildebrand F, Kaas RS, Kennedy S, Kristiansen K, Kultima JR, L??onard P, Levenez F, Lund O, Moumen B, Le Paslier D, Pons N, Pedersen O, Prifti E, Qin J, Raes J, S??rensen S, Tap J, Tims S, Ussery DW, Yamada T, Renault P, Sicheritz-Ponten T, Bork P, Wang J, Brunak S, Ehrlich SD 
  Laboratory: 1] Center for Biological Sequence Analysis, Technical University of Denmark, Kongens Lyngby, Denmark. [2] Novo Nordisk Foundation Center for Biosustainability, Technical University of Denmark, Kongens Lyngby, Denmark. [3]. 
  Contact information:  
  Title: Identification and assembly of genomes and genetic elements in complex metagenomic samples without using reference genomes 
  URL:  
  PMIDs: 24997787 

  Abstract: A 153 word abstract is available. Use 'abstract' method.
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
assayData: 302989 features, 382 samples
Platform type: NA
--------------------------- 
Available sample meta-data: 
--------------------------- 

dataset_name: 
Neilsen_genome_assembly 
                    382 

sampleID: 
   Length     Class      Mode 
      382 character character 

subjectID: 
   Length     Class      Mode 
      382 character character 

bodysite: 
stool 
  382 

disease: 
     ibd_crohn_disease ibd_ulcerative_colitis                      n             n_relative 
                    21                    127                    187                     47 

age: 
   Length     Class      Mode 
      382 character character 

gender: 
female   male 
   222    160 

country: 
denmark   spain 
    163     219 

sequencing_technology: 
Illumina 
     382 

pubmedid: 
24997787 
     382 

bmi: 
   Length     Class      Mode 
      382 character character 

X.SampleID: 
Metaphlan2_Analysis 
                382 

sampling_day: 
   Length     Class      Mode 
      382 character character 

known_consumers_of_a_defined_fermented_milk_product_.dfmp.: 
dfmp   na 
  19  363 

mgs_richness: 
   Length     Class      Mode 
      382 character character 

mgs_profile_matched_sample_pairs: 
   Length     Class      Mode 
      382 character character 

ethnicity: 
white 
  382 

}}
\keyword{datasets}
