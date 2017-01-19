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

*curatedMetagenomicData* is a *Bioconductor* package that uses *ExperimentHub* to access a large number (n ≈ 3000) of human microbiome samples gathered from various sources.

The project is part of a larger pipeline and processes data from the [HUMAnN2](https://bitbucket.org/biobakery/humann2/wiki/Home){:target="_blank"} and [MetaPhlAn2](https://bitbucket.org/biobakery/metaphlan2){:target="_blank"} pipelines. Although much of the pipeline is of little consequence to the end user, it is shown below for illustration.

<figure>
    <img src="/assets/img/figure_1.png" alt="figure_1">
</figure>

It is rather the integrated and distributed datasets that *curatedMetagenomicData* delivers most users will find of interest. The package provides taxonomic, functional, and gene marker abundance data that has been highly processed, refined, and curated such that analysis requires a minimum of bioinformatic expertise and no preprocessing of data.

As shown above, problems such as classification, clustering, and correlation analysis can be done in a few lines of code and across multiple studies. The barrier of working with large-scale, raw sequencing data has been abstracted from the process of microbiome data analysis and work that would otherwise have required a computing cluster can be done on a laptop.

It is hoped that, with the provision of resources in curatedMetagenomicData, microbiome analysis will be significantly enabled in a manner that is highly reproducible. Finally, into the future, the development of curatedMetagenomicData will continue with the addition, curation, and analysis of further microbiome datasets.
