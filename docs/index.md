---
layout: default
title: curatedMetagenomicData
---
[![Support Site Activity](https://bioconductor.org/shields/posts/curatedMetagenomicData.svg)](https://support.bioconductor.org/t/curatedmetagenomicdata/){:target="_blank"}
[![Build Results](https://bioconductor.org/shields/build/devel/data-experiment/curatedMetagenomicData.svg)](https://bioconductor.org/checkResults/devel/data-experiment-LATEST/curatedMetagenomicData/){:target="_blank"}
[![Travis-CI Build Status](https://travis-ci.org/waldronlab/curatedMetagenomicData.svg?branch=master)](https://travis-ci.org/waldronlab/curatedMetagenomicData){:target="_blank"}
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/waldronlab/curatedMetagenomicData?branch=master&svg=true)](https://ci.appveyor.com/project/schifferl/curatedmetagenomicdata-o9eib){:target="_blank"}
[![Coverage Status](https://img.shields.io/codecov/c/github/waldronlab/curatedMetagenomicData/master.svg)](https://codecov.io/github/waldronlab/curatedMetagenomicData?branch=master){:target="_blank"}
[![Subversion Commits](https://bioconductor.org/shields/commits/data-experiment/curatedMetagenomicData.svg)](https://bioconductor.org/packages/devel/data/experiment/html/curatedMetagenomicData.html#svn_source){:target="_blank"}

We present *curatedMetagenomicData*, a Bioconductor package that uses *ExperimentHub* to access a large number of processed and curated metagenomic samples from the human microbiome gathered from various sources.

The project is part of a larger pipeline and processes data from the [HUMAnN2](https://bitbucket.org/biobakery/humann2/wiki/Home){:target="_blank"} and [MetaPhlAn2](https://bitbucket.org/biobakery/metaphlan2){:target="_blank"} pipelines. Although much of the pipeline is of little consequence to the end user, it is shown below for illustration.

<figure>
    <img src="/curatedMetagenomicData/assets/img/figure_1.png" alt="figure_1">
</figure>

It is rather the integrated and distributed datasets that *curatedMetagenomicData* delivers most users will find of interest. The package provides taxonomic, functional, and gene marker abundance data that has been highly processed, refined, and curated such that analysis requires a minimum of bioinformatic expertise and no preprocessing of data.

As shown above, problems such as classification, clustering, and correlation analysis can be done in a few lines of code and across multiple studies. The barrier of working with large-scale, raw sequencing data has been abstracted from the process of microbiome data analysis and work that would otherwise have required a computing cluster can be done on a laptop.

It is hoped that, with the provision of resources in *curatedMetagenomicData*, microbiome analysis will be significantly enabled in a manner that is highly reproducible. Finally, into the future, the development of *curatedMetagenomicData* will continue with the addition, curation, and analysis of further microbiome datasets. Shown below is a list of forthcoming datasets that have been chosen for inclusion in curatedMetagenomicData.

| Dataset Name | PMID | Publication Year | Bodysite | Disease | Number of Samples | 
| --- | --- | --- | --- | --- | --- | 
| BarnardE_2016 | 28000755 | 2016 | Skin | Acne | 78 | 
| GeveresD_2014 | 24629344 | 2014 | Stool | CD | 50 | 
| HMP_phaseII |  |  | Several | Other condition | 1200 | 
| HMP2 |  |  | Several | IBD, T2D | 3528 | 
| HuangAD_2016 | 27881416 | 2016 | Stool | Other condition | 10 | 
| KorpelaK_2016 | 26811868 | 2016 | Stool | Other condition | 256 | 
| KosticAD_2015 | 25662751 | 2015 | Stool | T1D | 124 | 
| LiJ_2014 | 24997786 | 2014 | Stool | Other condition | 260 | 
| LiJ_2017 | 28143587 | 2017 | Stool | Hypertension | 196 | 
| LiSS_2016 | 27126044 | 2016 | Stool | Other condition | 430 | 
| LuisS_2016 | 26919743 | 2016 | Stool | Obesity | 92 | 
| ManorO_2016 | 26940651 | 2016 | Stool | Cystic fibrosis | 104 | 
| MilaniC_2016 | 27166072 | 2016 | Stool | CDI | 15 | 
| MurphyR_2016 | 27738970 | 2016 | Stool | T2D | 28 | 
| Nagy-SzakalD_2017 | 28441964 | 2017 | Stool | ME/CFS | 100 | 
| OhJ_2016 | 27153496 | 2016 | Skin | Other condition | 406 | 
| OlmMR_2017 | 28073918 | 2017 | Stool, skin, oral | Other condition | 45 | 
| PehrssonEC_2016 | 27172044 | 2016 | Stool | Other condition | 116 | 
| PiperHG_2016 | 27406942 | 2016 | Stool | SBS | 11 | 
| QuinceC_2015 | 26526081 | 2015 | Stool | IBD | 117 | 
| RoseG_2017 | 5270596 | 2017 | Stool | Other condition | 15 | 
| ScherJU_2013 | 24192039 | 2013 | Stool | Other condition | 44 | 
| TremaroliV_2015 | 26244932 | 2016 | Stool | Other condition | 21 | 
| VoigtAY_2015 | 25888008 | 2015 | Stool | Other condition | 70 | 
| YassourM_2016 | 27306663 | 2016 | Stool | Other condition | 240 | 
| ZeeviD_2015 | 26590418 | 2015 | Stool | Other condition | 1523 | 
| ZehernakovaA_2016 | 27126040 | 2016 | Stool | Other condition | 1135 | 
| ZhangX_2015 | 26214836 | 2015 | Stool | Rheumatoid arthritis | 202 | 

Authors welcome the addition of new datasets provided they can be run through the MetaPhlAn2 and HUMAnN2 pipelines and have curated per sample metadata. To have a dataset considered for addition please contact the maintainer and provide a TSV file containing curated per sample metadata, along with information about how the raw data can be transfered (SCP, SFTP, etc.) for processing. Provided the dataset is a curated human metagenomic study that can be run through the MetaPhlAn2 and HUMAnN2 pipelines it will be added by the process outlined in the [wiki](https://github.com/waldronlab/curatedMetagenomicData/wiki/Adding-New-Data){:target="_blank"} as soon as is practically possible.

Development of the *curatedMetagenomicData* package occurs on GitHub and bugs
reported via GitHub issues will recieve the quickest response. Please visit the
[project repository](https://github.com/waldronlab/curatedMetagenomicData){:target="_blank"} and
file an issue should you find one.

If you have an issue that is not documented elsewhere, visit the Bioconductor support site at [https://support.bioconductor.org/](https://support.bioconductor.org/){:target="_blank"},
breifly describe your issue, add the tag curatedMetagenomicData, and we will see it.
