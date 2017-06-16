---
layout: default
title: Getting Started
---
Installing *curatedMetagenomicData* should generally be done through `R` following the procedure as shown below. However there is an alternative method to install *curatedMetagenomicData* that is also shown below. Of course both `R` and `Bioconductor` should be installed prior to installing *curatedMetagenomicData*, installation recommendations are also below.

Finally, there are additional instructions for accessing data that follow the installation instructions. It is possible to get data from *curatedMetagenomicData* both from within `R` and from the command line.
=======
Installing `curatedMetagenomicData` should be done through the Bioconductor package manager `biocLite()`.  Note that accessing the most recent datasets requires the *development* version of Bioconductor. Trying to install the development version of curatedMetagenomicData on top of the release version of Bioconductor won't allow you to access datasets that have been added since the last Bioconductor release.
>>>>>>> levi

## Install R and Bioconductor

To install the *release* version, follow instructions for installing `R` and `Bioconductor` from [https://www.bioconductor.org/install/](https://www.bioconductor.org/install/). 

To install the *development* version, follow the instructions at [http://bioconductor.org/developers/how-to/useDevel/](http://bioconductor.org/developers/how-to/useDevel/). 

If you're not sure which version to use, look at the "reference manual" for the [release](https://bioconductor.org/packages/curatedMetagenomicData/) and [development](https://bioconductor.org/packages/devel/data/experiment/html/curatedMetagenomicData.html) versions. 

## Install curatedMetagenomicData

### Through R/Bioconductor

<<<<<<< HEAD
This is the usual way to install *curatedMetagenomicData* and is preferred in most cases. From `R`,

Do either this:

{% highlight r %}
BiocInstaller::biocLite("curatedMetagenomicData")
{% endhighlight %}

Or this:
=======
This is the usual way to install `curatedMetagenomicData` and is preferred in most cases. You must have Bioconductor installed already.
>>>>>>> levi

{% highlight r %}
library(BiocInstaller)
biocLite("curatedMetagenomicData")
{% endhighlight %}

<<<<<<< HEAD
Both are equivalent.

### Using devtools

It is also possible to use `biocLite` to install *curatedMetagenomicData* from GitHub. Know that this method will install the most up to date source and the software may contain bugs. From `R`,

Do either this:

{% highlight r %}
BiocInstaller::biocLite("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
{% endhighlight %}

Or this:
=======
If you are running the development version of Bioconductor, you can also install directly from Github for the "bleeding edge" version, which may contain bugs:
>>>>>>> levi

{% highlight r %}
library(BiocInstaller)
biocLite("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
{% endhighlight %}

## Accessing Data

### From within R
<<<<<<< HEAD
*curatedMetagenomicData* and its related data can be accessed through `R` using `Bioconductor` and `ExperimentHub`. To install the necessary software see our install section above.

With *curatedMetagenomicData* installed, you can access datasets through `R` like this:

{% highlight r %}
library(curatedMetagenomicData)
eset = LomanNJ_2013.metaphlan_bugs_list.stool()
{% endhighlight %}

From the resulting `ExpressionSet` object you can extract metagenomic data with `exprs(eset)`, participant and sequencing information using `pData(eset)`, and study information using `experimentData(eset)`.

The Metaphlan bugs datasets can be converted to `phyloseq` objects for use with the excellent [phyloseq](https://bioconductor.org/packages/phyloseq){:target="_blank"} Bioconductor package. See `ExpressionSet2phyloseq` for more details on this conversion:

{% highlight r %}
ExpressionSet2phyloseq(eset, simplify = TRUE, relab = FALSE )
{% endhighlight %}

Further usage instructions beyond these basic steps are available in the [package vignette](https://bioconductor.org/packages/release/data/experiment/vignettes/curatedMetagenomicData/inst/doc/curatedMetagenomicData.html){:target="_blank"}.

The list of datasets currently included in the package is available in the [reference manual](http://bioconductor.org/packages/release/data/experiment/manuals/curatedMetagenomicData/man/curatedMetagenomicData.pdf){:target="_blank"}.


### From the Command Line
In order to access data from the command line it is necessary to have `R`, `Bioconductor`, and *curatedMetagenomicData* installed (see the install section above). Additionally, it is necessary to install the `docopt` package from within `R`:

{% highlight r %}
BiocInstaller::biocLite("docopt")
=======
*curatedMetagenomicData* and its related data can be accessed through *R* using *Bioconductor* & *ExperimentHub*. 

The recommended way to access data from within R is with the `curatedMetagenomicData()` function. For example:

{% highlight r %}
library(curatedMetagenomicData)
res <- curatedMetagenomicData("HMP_2012.metaphlan_bugs_list.stool", dryrun=FALSE) #one dataset
res <- curatedMetagenomicData("HMP_2012.metaphlan_bugs_list.*") #many datasets
>>>>>>> levi
{% endhighlight %}

See:

<<<<<<< HEAD
1. Downloading the *curatedMetagenomicData* [shell script](https://raw.githubusercontent.com/waldronlab/curatedMetagenomicData/master/inst/commandline/curatedMetagenomicData){:target="_blank"}.
=======
* `?curatedMetagenomicData` for more options to this function, including whether to return relative abundances or counts, conversion of taxonomic tables to [phyloseq](https://bioconductor.org/packages/phyloseq/) objects, and versioning
* `help(package="curatedMetagenomicData")` for all datasets and available functions
>>>>>>> levi

See the [package vignette](https://bioconductor.org/packages/release/data/experiment/vignettes/curatedMetagenomicData/inst/doc/curatedMetagenomicData.html) for additional instructions, and [vignettes/extras](https://github.com/waldronlab/curatedMetagenomicData/tree/master/vignettes/extras) for code to reproduce results of [our manuscript](biorxiv.org/content/early/2017/01/27/103085).

### Command line usage

Set up curatedMetagenomicData as above, then use the shell script provided in the [inst/commandline](https://github.com/waldronlab/curatedMetagenomicData/tree/master/inst/commandline) package directory. This script generates tab-separated value files and takes similar arguments to the R function.
