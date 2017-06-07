# Contributing to curatedMetagenomicData

*curatedMetagenomicData* aims to embody the spirit of open-source software, reproducibility, and to provide an ever growing collection of metagenomic data. As such, reports of bugs and curation errors, and suggestions and curation of relevant new metagenomic datasets will gladly be accepted.

The package is described at https://waldronlab.github.io/curatedMetagenomicData/, including information for installation and example analyses. 

## Reporting Bugs and Errors in Curation

Development of the *curatedMetagenomicData* package occurs on GitHub. Please visit the
[project repository](https://github.com/waldronlab/curatedMetagenomicData) and report software bugs and data problems on our [issue tracker](https://github.com/waldronlab/curatedMetagenomicData/issues).

## Pull Request

If you are able to fix a bug yourself, or wish to add an analysis example, we would welcome a pull request. If the pull request builds cleanly on the continuous itegration servers it will be merged as soon as is possible.

## Addition of Datasets to curatedMetagenomicData

Authors welcome the addition of new metagenomic datasets provided that the raw data are hosted by NCBI/SRA and can be run through our [MetaPhlAn2 and HUMAnN2 pipeline](https://github.com/waldronlab/curatedMetagenomicData/tree/master/inst/pipeline). You can request the addition of a dataset by opening an issue on the [issue tracker](https://github.com/waldronlab/curatedMetagenomicData/issues), pointing us to the publication and raw data. 

You can speed up our ability to incorporate a new dataset by providing curated metadata. Metadata must satisfy a grammar that is defined by this [template](https://github.com/waldronlab/curatedMetagenomicData/blob/master/inst/extdata/template.csv). You can check that a data.frame object satisfies this grammar using the checkCuration() function in *curatedMetagenomicData*.

## Using the curatedMetagenomicData Pipeline Yourself

The process of adding a dataset is documented in the [wiki](https://github.com/waldronlab/curatedMetagenomicData/wiki/Adding-New-Data). Critical components are the [High Computational Load Pipeline](https://github.com/waldronlab/curatedMetagenomicData/tree/master/inst/pipeline) and the [curatedMetagenomicData Generating Pipeline](https://github.com/waldronlab/curatedMetagenomicData/tree/master/data-raw).

## Other Issues

If you have an issue that is not documented elsewhere, visit the Bioconductor support site at https://support.bioconductor.org/, briefly describe your issue, and add the tag curatedMetagenomicData.
