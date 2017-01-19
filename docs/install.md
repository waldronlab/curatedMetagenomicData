---
layout: default
title: Install
---
Installing `curatedMetagenomicData` should generally be done through `R` following the procedure as shown below. However there are a number of alternative methods to install `curatedMetagenomicData` that are also shown below. Of course both `R` and `Bioconductor` should be installed prior to installing `curatedMetagenomicData`, installation recommendations are also below.

## Install R and Bioconductor

1. Install `R` by following instructions found at [https://www.r-project.org/](https://www.r-project.org/).

2. Install `Bioconductor` from `R` by following instructions found at [https://www.bioconductor.org/install/](https://www.bioconductor.org/install/).

3. Optionally install `RStudio` to make using `R` easier by following instructions found at [https://www.rstudio.com/products/RStudio/](https://www.rstudio.com/products/RStudio/).

## Install curatedMetagenomicData

### Through R/Bioconductor

This is the usual way to install `curatedMetagenomicData` and is preferred in most cases. From R,

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

It is also possible to use `biocLite` to install `curatedMetagenomicData` from GitHub. Know that this method will install the most up to date source and the software may contain bugs. From R,

Do either this:

{% highlight r %}
BiocInstaller::biocLite("waldronlab/curatedMetagenomicData",
                        dependencies = TRUE, build_vignettes = TRUE)
{% endhighlight %}

Or this:

{% highlight r %}
library(BiocInstaller)
biocLite("waldronlab/curatedMetagenomicData", dependencies = TRUE,
         build_vignettes = TRUE)
{% endhighlight %}

Again, both are equivalent.
