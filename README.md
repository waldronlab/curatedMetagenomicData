
<!-- README.md is generated from README.Rmd. Please edit that file -->

# curatedMetagenomicData

<!-- badges: start -->

[![code
quality](https://img.shields.io/codefactor/grade/github/waldronlab/curatedMetagenomicData)](https://www.codefactor.io/repository/github/waldronlab/curatedmetagenomicdata)
[![coverage](https://img.shields.io/codecov/c/github/waldronlab/curatedMetagenomicData)](https://codecov.io/gh/waldronlab/curatedMetagenomicData)
<!-- badges: end -->

The
*[curatedMetagenomicData](https://bioconductor.org/packages/3.22/curatedMetagenomicData)*
package provides standardized, curated human microbiome data for novel
analyses. It includes marker abundance, marker presence, and relative
abundance for samples collected from different body sites, with gene
families, pathway abundance, and pathway coverage reinstated as they are
added to the cMD4 catalog. The bacterial, fungal, and archaeal taxonomic
abundances for each sample were calculated with
[MetaPhlAn3](https://github.com/biobakery/MetaPhlAn), and metabolic
functional potential was calculated with
[HUMAnN3](https://github.com/biobakery/humann). The manually curated
sample metadata and standardized metagenomic data are available as
(Tree)SummarizedExperiment objects.

## What’s new in cMD 4.0 (“cMD4”)

Starting with version 4.0.0,
*[curatedMetagenomicData](https://bioconductor.org/packages/3.22/curatedMetagenomicData)*
serves sample-level profiling data from the published cMD4 DuckDB
catalog of hive-partitioned parquet files produced by
`curatedMetagenomicDataETL`, replacing the cMD3 ExperimentHub backend.
The user-facing API is unchanged: `curatedMetagenomicData()`,
`returnSamples()`, and `mergeData()` keep their signatures (including
`dryrun`, `counts`, and `rownames`) and still return
`(Tree)SummarizedExperiment` objects, so existing user code continues to
work.

Key changes:

- **Harmonized metadata objects.** The legacy `sampleMetadata` object
  has been replaced by two `data.frame` exports shipped directly with
  the package: `harmonized_meta` (one row per sample, restricted to
  columns defined in the cMD harmonization schema) and `all_meta` (the
  same rows plus study-specific columns still under harmonization). Both
  expose `study_name` and `sample_id` for use with
  `curatedMetagenomicData()` and `returnSamples()`.
- **Catalog URL.** Defaults to
  `https://minio.cancerdatasci.org/cmgd-export/cmgd.duckdb`; override
  with `options(curatedMetagenomicData.duckdb_url = ...)`.
- **Resource titles.** Still use the cMD3 dotted format
  `<runDate>.<study_name>.<dataType>`. Because the cMD4 ETL produces a
  single dated snapshot, `<runDate>` is a fixed release tag (`"cmd4"` by
  default, override with
  `options(curatedMetagenomicData.run_date = ...)`).
- **HUMAnN3 data types temporarily unavailable.** `gene_families`,
  `pathway_abundance`, and `pathway_coverage` are not yet in the cMD4
  catalog and currently raise an error if requested; they will be
  reinstated as soon as they are added to the ETL output.
- **Runtime dependencies.** The runtime package no longer depends on
  `curatedMetagenomicDataCuration`, `ExperimentHub`, or `AnnotationHub`.

See `NEWS.md` and the vignette for the full set of changes.

## Installation

To install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.22/curatedMetagenomicData)*
from Bioconductor, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r
BiocManager::install("curatedMetagenomicData")
```

To install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.22/curatedMetagenomicData)*
from GitHub, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r
BiocManager::install("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
```

Most users should simply install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.22/curatedMetagenomicData)*
from Bioconductor.

## Sample metadata

*[curatedMetagenomicData](https://bioconductor.org/packages/3.22/curatedMetagenomicData)*
ships two curated sample metadata tables that users typically explore
before pulling assay data:

``` r
# schema-only, portable cohort assembly
harmonized_meta

# schema plus study-specific columns still under harmonization
all_meta
```

Both tables include `study_name` (used with `curatedMetagenomicData()`
to query resources) and `sample_id` (used with `returnSamples()` to pull
samples across studies).

## Examples

To access curated metagenomic data, users will use the
`curatedMetagenomicData()` function both to query and return resources.
Multiple resources can be queried or returned with a single call, but
only the titles of resources are returned by default.

``` r
curatedMetagenomicData("AsnicarF_20.+")
## cmd4.AsnicarF_2017.relative_abundance
## cmd4.AsnicarF_2021.relative_abundance
## cmd4.AsnicarF_2017.viral_clusters
## cmd4.AsnicarF_2021.viral_clusters
## cmd4.AsnicarF_2017.marker_abundance
## cmd4.AsnicarF_2021.marker_abundance
## cmd4.AsnicarF_2017.marker_presence
## cmd4.AsnicarF_2021.marker_presence
## cmd4.AsnicarF_2017.marker_rel_ab_w_read_stats
## cmd4.AsnicarF_2021.marker_rel_ab_w_read_stats
```

When the `dryrun` argument is set to `FALSE`, a `list` of
`SummarizedExperiment` and/or `TreeSummarizedExperiment` objects is
returned. The `rownames` argument determines the type of `rownames` to
use for `relative_abundance` resources: either `"long"` (the default),
`"short"` (species name), or `"NCBI"` (NCBI Taxonomy ID). When a single
resource is requested, a single-element `list` is returned.

``` r
curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, rownames = "short")
## $cmd4.AsnicarF_2017.relative_abundance
## class: TreeSummarizedExperiment 
## dim: 53 24 
## metadata(0):
## assays(1): relative_abundance
## rownames(53): Candidatus Gastranaerophilales bacterium Staphylococcus
##   epidermidis ... Parvimonas micra Peptoniphilus lacrimalis
## rowData names(7): superkingdom phylum ... genus species
## colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
##   MV_MIM5_t3F15
## colData names(20): study_name sample_id ... sex westernized
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: a LinkDataFrame (53 rows)
## rowTree: 1 phylo tree(s) (10430 leaves)
## colLinks: NULL
## colTree: NULL
```

When the `counts` argument is set to `TRUE`, relative abundance
proportions are multiplied by read depth and rounded to the nearest
integer prior to being returned. When multiple resources are requested,
the `list` contains named elements corresponding to each
`SummarizedExperiment` and/or `TreeSummarizedExperiment` object.

``` r
curatedMetagenomicData("AsnicarF_20.+.relative_abundance", dryrun = FALSE, counts = TRUE, rownames = "short")
## Warning: `number_reads` missing in `all_meta` for 24 sample(s); their count
## assay values will be NA.
## Warning: `number_reads` missing in `all_meta` for 178 sample(s); their count
## assay values will be NA.
## $cmd4.AsnicarF_2017.relative_abundance
## class: TreeSummarizedExperiment 
## dim: 53 24 
## metadata(0):
## assays(1): relative_abundance
## rownames(53): Candidatus Gastranaerophilales bacterium Staphylococcus
##   epidermidis ... Parvimonas micra Peptoniphilus lacrimalis
## rowData names(7): superkingdom phylum ... genus species
## colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
##   MV_MIM5_t3F15
## colData names(20): study_name sample_id ... sex westernized
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: a LinkDataFrame (53 rows)
## rowTree: 1 phylo tree(s) (10430 leaves)
## colLinks: NULL
## colTree: NULL
## 
## $cmd4.AsnicarF_2021.relative_abundance
## class: TreeSummarizedExperiment 
## dim: 61 178 
## metadata(0):
## assays(1): relative_abundance
## rownames(61): Candidatus Gastranaerophilales bacterium Enterococcus
##   casseliflavus ... Tissierellia bacterium KA00581 Saccharomyces
##   cerevisiae
## rowData names(7): superkingdom phylum ... genus species
## colnames(178): SAMEA7041148 SAMEA7041149 ... SAMEA7045127 SAMEA7045128
## colData names(25): study_name sample_id ... sex westernized
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: a LinkDataFrame (61 rows)
## rowTree: 1 phylo tree(s) (10430 leaves)
## colLinks: NULL
## colTree: NULL
```

For cross-study cohort assembly, filter `harmonized_meta` (or
`all_meta`) to the samples of interest and pass the result to
`returnSamples()`:

``` r
library(dplyr)

harmonized_meta |>
    filter(age_years >= 18, !is.na(bmi), body_site == "feces") |>
    returnSamples("relative_abundance", rownames = "short")
```

## Analyses

See
[curatedMetagenomicAnalyses](https://github.com/waldronlab/curatedMetagenomicAnalyses)
for analyses in R and Python using
*[curatedMetagenomicData](https://bioconductor.org/packages/3.22/curatedMetagenomicData)*.

## Contributing

To contribute to the
*[curatedMetagenomicData](https://bioconductor.org/packages/3.22/curatedMetagenomicData)*
R/Bioconductor package, first read the [contributing
guidelines](CONTRIBUTING.md) and then open an issue. Also, note that in
contributing you agree to abide by the [code of
conduct](CODE_OF_CONDUCT.md).

------------------------------------------------------------------------

Pasolli E, Schiffer L, Manghi P, Renson A, Obenchain V, Truong D,
Beghini F, Malik F, Ramos M, Dowd J, Huttenhower C, Morgan M, Segata N,
Waldron L (2017). Accessible, curated metagenomic data through
ExperimentHub. *Nat. Methods*, **14** (11), 1023-1024. ISSN 1548-7091,
1548-7105, doi:
[10.1038/nmeth.4468](https://doi.org/10.1038/nmeth.4468).
