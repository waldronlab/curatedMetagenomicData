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

It is hoped that, with the provision of resources in curatedMetagenomicData, microbiome analysis will be significantly enabled in a manner that is highly reproducible. Finally, into the future, the development of curatedMetagenomicData will continue with the addition, curation, and analysis of further microbiome datasets. Shown below is a list of forthcoming datasets that have been chosen for inclusion in curatedMetagenomicData.

| Dataset Name | PMID | Publication Year | Bodysite | Disease | Number of Subjects | Number of Samples |
| --- | --- | --- | --- | --- | --- | --- |
| ChngKR_2016 | 27562258 | 2016 | skin | atopic dermatitis | 43 | 106 |
| KorpelaK_2016 | 26811868 | 2016 | gut | other condition | 142 | 256 |
| BonderJM_2016 | 27694959 | 2016 | gut | other condition | 471 | 1606 |
| Castro-NallarE_2015 | 26336637 | 2015 | oral_cavity | schizophrenia | 32 | 32 |
| ManorO_2016 | 26940651 | 2016 | gut | cystic fibrosis | 26 | 104 |
| MurphyR_2016 | 27738970 | 2016 | gut | T2D | 14 | 28 |
| QuinceC_2015 | 26526081 | 2015 | gut | IBD | 44 | 117 |
| VogtmannE_2016 | 27171425 | 2016 | gut | CRC | 104 | 104 |
| PiperHG_2016 | 27406942 | 2016 | gut | SBS | 11 | 11 |
| Heintz-BuschartA_2016 | 27775723 | 2016 | gut | T1D | 20 | 53 |
| LiuW_2016 | 27708392 | 2016 | gut | other condition | 110 | 110 |
| FengQ_2015 | 25758642 | 2015 | gut | CRC | 147 | 156 |
| RaymondF_2016 | 26359913 | 2016 | gut | other condition | 24 | 72 |
| XieH_2016 | 27818083 | 2016 | gut | other condition | 250 | 250 |
| SchirmerM_2016 | 27984736 | 2016 | gut | other condition | 489 | 471 |
| HuangAD_2016 | 27881416 | 2016 | gut | other condition | 10 | 10 |
| ZehernakovaA_2016 | 27126040 | 2016 | gut | other condition | 1135 | 1135 |
| YuJ_2015 | 26408641 | 2015 | gut | CRC | 128 | 128 |
| BritoIL_2016 | 27409808 | 2016 | oral_cavity, gut | other condition | 172 | 484 |
| OlmMR_2017 | 28073918 | 2017 | gut, skin, oral_cavity | other condition | 2 | 45 |
| HMPphaseII |  |  | gut, skin,oral_cavity, vagina | other condition | 300 | 1200 |
| HMP2 |  |  | gut, vagina | T2D, IBD |  | 3528 |
| KosticAD_2015 | 25662751 | 2015 | gut | T1D | 19 | 124 |
| YassourM_2016 | 27306663 | 2016 | gut | other condition | 39 | 240 |
| VatanenT_2016 | 27259157 | 2016 | gut | other condition | 222 | 785 |
| ScherJU_2013 | 24192039 | 2014 | gut | other condition | 44 | 44 |

Authors welcome the addition of new datasets provided they can be or already have been run through the MetaPhlAn2 and HUMAnN2 pipelines. Please read the [developer documentation](https://tinyurl.com/cMDReadme){:target="_blank"} and contact the maintainer if you have a shotgun metagenomic dataset that would be of interest to the Bioconductor community.
