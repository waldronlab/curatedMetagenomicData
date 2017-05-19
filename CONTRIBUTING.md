# Contributing to curatedMetagenomicData

Principally curatedMetagenomicData aims to embody the spirit of open-source software, reproducibility, and provide an ever growing collection of metagenomic data. As such, contributions will gladly be accepted provided they fit within the context of the project.

## Reporting Bugs

Please report software bugs and data problems on our GitHub [issue tracker](https://github.com/waldronlab/curatedMetagenomicData/issues).

## Pull Request

If you are able to fix a bug yourself, we would welcome a pull request. If the pull request builds cleanly on the continious itegration servers it will be merged as soon as is possible.

## Adding Datasets

Authors welcome the addition of new metagenomic datasets provided that the raw data are hosted by NCBI and can be run through the MetaPhlAn2 and HUMAnN2 pipelines. You 
can request the addition of a dataset by opening an issue on the [Issue Tracker](https://github.com/waldronlab/curatedMetagenomicData/issues), pointing
us to the publication and raw data. Provided the dataset is a curated human metagenomic study that can be run through the MetaPhlAn2 and HUMAnN2 pipelines it will be added by the process outlined in the [wiki](https://github.com/waldronlab/curatedMetagenomicData/wiki/Adding-New-Data) as soon as is practically possible.

You can speed up our ability to incorporate a new dataset by providing curated 
metadata. Metadata must satisfy a grammar that is defined by this [template](https://github.com/waldronlab/curatedMetagenomicData/blob/master/inst/extdata/template.csv). You can check that a data.frame object satisfies this grammar using the checkCuration() function in curatedMetagenomicData.


## Other Issues

Visit the Bioconductor support site at https://support.bioconductor.org/, briefly describe your issue, and add the tag curatedMetagenomicData.
