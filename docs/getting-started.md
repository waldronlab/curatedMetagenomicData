---
layout: default
title: Getting Started
---
Installing *curatedMetagenomicData* should generally be done through `R` following the procedure as shown below. However there is an alternative method to install *curatedMetagenomicData* that is also shown below. Of course both `R` and `Bioconductor` should be installed prior to installing *curatedMetagenomicData*, installation recommendations are also below.

Finally, there are additional instructions for accessing data that follow the installation instructions. It is possible to get data from *curatedMetagenomicData* both from within `R` and from the command line.

## Install R and Bioconductor

1. Install `R` by following instructions found at [https://www.r-project.org/](https://www.r-project.org/).

2. Install `Bioconductor` from `R` by following instructions found at [https://www.bioconductor.org/install/](https://www.bioconductor.org/install/).

3. Optionally install `RStudio` to make using `R` easier by following instructions found at [https://www.rstudio.com/products/RStudio/](https://www.rstudio.com/products/RStudio/).

## Install curatedMetagenomicData

### Through R/Bioconductor

This is the usual way to install *curatedMetagenomicData* and is preferred in most cases. From `R`,

Do either this:

{% highlight r %}
BiocInstaller::biocLite("curatedMetagenomicData")
{% endhighlight %}

Or this:

{% highlight r %}
library(BiocInstaller)
biocLite("curatedMetagenomicData")
{% endhighlight %}

Both are equivalent.

### Using devtools

It is also possible to use `biocLite` to install *curatedMetagenomicData* from GitHub. Know that this method will install the most up to date source and the software may contain bugs. From `R`,

Do either this:

{% highlight r %}
BiocInstaller::biocLite("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
{% endhighlight %}

Or this:

{% highlight r %}
library(BiocInstaller)
biocLite("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
{% endhighlight %}

Again, both are equivalent.

## Accessing Data

### From within R
*curatedMetagenomicData* and its related data can be accessed through `R` using `Bioconductor` and `ExperimentHub`. To install the necessary software see our install section above.

With *curatedMetagenomicData* installed, you can access datasets through `R` like this:

{% highlight r %}
library(curatedMetagenomicData)
eset = LomanNJ_2013_Hi.metaphlan_bugs_list.stool()
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
{% endhighlight %}

With the above completed, data can be accessed from the command line by:

1. Downloading the *curatedMetagenomicData* [shell script](https://raw.githubusercontent.com/waldronlab/curatedMetagenomicData/master/inst/commandline/curatedMetagenomicData){:target="_blank"}.

2. Making sure the shell script has executable permissions (i.e., `chmod a+x curatedMetagenomicData`)

3. Making sure the R executable at the top of the script is correct (by default `/usr/bin/Rscript`). Check where `Rscript` is installed by `which Rscript`.

4. Placing the *curatedMetagenomicData* file somewhere on your `PATH`, or invoke it using `./curatedMetagenomicData`. Use `./curatedMetagenomicData -h` to see its help.
