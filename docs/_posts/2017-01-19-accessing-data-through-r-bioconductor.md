---
layout: post
title:  "Accessing Data through R/Bioconductor"
date:   2017-01-19
---
*curatedMetagenomicData* and its related data can be accessed through *R* using *Bioconductor* & *ExperimentHub*. To install the necessary software see our install section.

With *curatedMetagenomicData* installed, you can access datasets through *R* like this:

{% highlight r %}
library(curatedMetagenomicData)
eset = LomanNJ_2013_Hi.metaphlan_bugs_list.stool()
{% endhighlight %}

From the resulting *ExpressionSet* object you can extract metagenomic data with `exprs(eset)`, participant and sequencing information using `pData(eset)`, and study information using `experimentData(eset)`.

The Metaphlan bugs datasets can be converted to *phyloseq* objects for use with the excellent [phyloseq](bioconductor.org/packages/phyloseq){:target="_blank"} Bioconductor package (see `?ExpressionSet2phyloseq`) for more details on this conversion:

{% highlight r %}
ExpressionSet2phyloseq(eset, simplify = TRUE, relab = FALSE )
{% endhighlight %}

Further usage instructions beyond these basic steps are available in the [package vignette](https://bioconductor.org/packages/release/data/experiment/vignettes/curatedMetagenomicData/inst/doc/curatedMetagenomicData.html){:target="_blank"}. A list of all datasets is available in the [reference manual](http://bioconductor.org/packages/release/data/experiment/manuals/curatedMetagenomicData/man/curatedMetagenomicData.pdf){:target="_blank"}.
