---
layout: post
title: "Paper Figures"
date:  2017-06-06
---

All results shown in our [manuscript](http://biorxiv.org/content/early/2017/01/27/103085){:target="_blank"} are reproducible using the [PaperFigures.Rmd](https://github.com/waldronlab/curatedMetagenomicData/tree/master/vignettes/extras){:target="_blank"} script in the package's `vignettes/extras` directory. This script is useful for demonstrating numerous supervised and unsupervised analyses, but it does not use the most up-to-date convenience functions available in curatedMetagenomicData (it uses an `ExperimentHub` object directly instead of the `curatedMetagenomicData()` function, and does not make use of the `ExpressionSet2phyloseq()` function that are now available in the package.
