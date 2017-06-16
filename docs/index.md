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

*curatedMetagenomicData* is a Bioconductor package providing uniformly processed and manually annotated human microbiome profiles for thousands of people [already included](datasets-included.md) and [planned for inclusion](datasets-ongoing.md) in the database. Microbial taxonomy and metabolic functional potential can be analyzed with respect to numerous participant characteristics and health outcomes, simply and reproducibly on a normal laptop. 

Each dataset provides taxonomic abundance, gene marker presence and absence (from [MetaPhlAn2](https://bitbucket.org/biobakery/metaphlan2)), plus coverage and abundance of metabolic pathways and gene families abundance (from [HUMAnN2](https://bitbucket.org/biobakery/humann2/wiki/Home)). Metagenomic data with matched health and socio-demographic data are provided as Bioconductor **ExpressionSet** objects, with options for automatic conversion of taxonomic profiles to [phyloseq](https://bioconductor.org/packages/phyloseq) or [metagenomeSeq](https://bioconductor.org/packages/metagenomeSeq/) objects for microbiome-specific analyses. WeFor more detail, see the pre-print at [biorxiv.org/content/early/2017/01/27/103085](biorxiv.org/content/early/2017/01/27/103085) and the [Analyses](https://waldronlab.github.io/curatedMetagenomicData/analyses) menu item above.


*curatedMetagenomicData* aims to embody the spirit of open-source software, reproducibility, and to provide an ever growing collection of metagenomic data provided under the [Artistic License 2.0](https://github.com/waldronlab/curatedMetagenomicData/blob/master/LICENSE). Please visit the [CONTRIBUTING](https://github.com/waldronlab/curatedMetagenomicData/blob/master/CONTRIBUTING.md) page if you are willing to contribute reports of bugs and curation errors, suggest relevant new datasets, or provide curation and code. 
