---
layout: default
title: Getting Started
---
Installing *curatedMetagenomicData* should be done through the Bioconductor package manager `biocLite()`. Note that accessing the most recent datasets requires the development version of Bioconductor. Trying to install the development version of curatedMetagenomicData on top of the release version of Bioconductor won't allow you to access datasets that have been added since the last Bioconductor release.

## Install R and Bioconductor

To install the *release* version, follow instructions for installing `R` and `Bioconductor` from [https://www.bioconductor.org/install/](https://www.bioconductor.org/install/){:target="_blank"}. 

To install the *development* version, follow the instructions at [http://bioconductor.org/developers/how-to/useDevel/](http://bioconductor.org/developers/how-to/useDevel/){:target="_blank"}. 

If you're not sure which version to use, look at the "Reference Manual" for the [release](https://bioconductor.org/packages/curatedMetagenomicData/){:target="_blank"} and [development](https://bioconductor.org/packages/devel/data/experiment/html/curatedMetagenomicData.html){:target="_blank"} versions. 

## Install curatedMetagenomicData

### Through R/Bioconductor

This is the usual way to install *curatedMetagenomicData* and is preferred in most cases. You must have Bioconductor installed already.

{% highlight r %}
library(BiocInstaller)
biocLite("curatedMetagenomicData")
{% endhighlight %}

If you are running the development version of Bioconductor, you can also install directly from Github for the "bleeding edge" version, which may contain bugs:

{% highlight r %}
library(BiocInstaller)
biocLite("waldronlab/curatedMetagenomicData", dependencies = TRUE,
         build_vignettes = TRUE)
{% endhighlight %}

## Accessing Data

### From within R
*curatedMetagenomicData* and its related data can be accessed through R using Bioconductor and ExperimentHub. 

The recommended way to access data from within R is with the `curatedMetagenomicData()` function. For example:

{% highlight r %}
library(curatedMetagenomicData)
res <- curatedMetagenomicData("HMP_2012.metaphlan_bugs_list.stool", dryrun=FALSE) #one dataset
res <- curatedMetagenomicData("HMP_2012.metaphlan_bugs_list.*", dryrun=FALSE) #many datasets
{% endhighlight %}

See:

* `help(package="curatedMetagenomicData")` for all datasets and available functions
* `?curatedMetagenomicData` for more options to this function, including whether to return relative abundances or counts, conversion of taxonomic tables to [phyloseq](https://bioconductor.org/packages/phyloseq/){:target="_blank"} objects, and versioning
* `?combined_metadata` or `View(combined_metadata)` for a table of all participants and their annotations.
See the [package vignette](https://bioconductor.org/packages/devel/data/experiment/vignettes/curatedMetagenomicData/inst/doc/curatedMetagenomicData.html){:target="_blank"} for additional instructions, and [vignettes/extras](https://github.com/waldronlab/curatedMetagenomicData/tree/master/vignettes/extras) for code to reproduce results of [our manuscript](http://biorxiv.org/content/early/2017/06/21/103085){:target="_blank"}.

### Command line usage

Set up *curatedMetagenomicData* as above, then use the shell script provided in the [inst/commandline](https://github.com/waldronlab/curatedMetagenomicData/tree/master/inst/commandline) package directory. This script generates tab-separated value files and takes similar arguments to the R function.
