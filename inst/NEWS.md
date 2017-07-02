# curatedMetagenomicData 1.5.7

* doubled the number of samples to over 5,700
* made naming of metadata more complete and strict, see inst/extdata/template.csv
* mergeData() function for convenient merging of datasets
* combined_metadata table providing all sample information for all studies

# curatedMetagenomicData 1.3.5

* Data updated to include accession numbers
* Minor updates to PaperFigures.Rmd vignette for reproducibility

# curatedMetagenomicData 1.1.9

* Vast improvements to documentation, now more informative and compact
* New function to coerce data to an MRexperiment class
* New workhorse function to access data with wildcard search
* Fun intro message for developers

# curatedMetagenomicData 1.1.4

* Version bumped to reflect latest y version of Bioconductor
* Fixed a bug related to ExperimentHub that caused checks to fail

# curatedMetagenomicData 1.0.4

* Fixed a bug related to ExperimentHub that caused checks to fail

# curatedMetagenomicData 1.0.0

* Package vignette is updated to reflect in the intended use of ExperimentHub
* Object level documentation is update for completeness and aliased
* Minor description file changes to ensure collation order
* Version bumped to reflect latest y version of Bioconductor
* All data is reprocessed in R (v3.3.2)

# curatedMetagenomicData 0.99.8

* Codebase is completely refactored to ExperimentHub specifications
* Package vignette is updated to Rmd syntax and uses BiocStyle
* New parallel functions allow for faster data processing
* Documentation updated to use roxygen2
* All data is reprocessed in R (v3.3.1)
* All raw data is reprocessed with MetaPhlAn2 (v2.2.0) & HUMAnN2 (v0.7.0)