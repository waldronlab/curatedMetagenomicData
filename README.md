
<!-- README.md is generated from README.Rmd. Please edit that file -->

# curatedMetagenomicData

<!-- badges: start -->

[![R CMD
check](https://github.com/waldronlab/curatedMetagenomicData/actions/workflows/ci.yml/badge.svg)](https://github.com/waldronlab/curatedMetagenomicData/actions/workflows/ci.yml)
[![code
quality](https://img.shields.io/codefactor/grade/github/waldronlab/curatedMetagenomicData)](https://www.codefactor.io/repository/github/waldronlab/curatedmetagenomicdata)
[![coverage](https://img.shields.io/codecov/c/github/waldronlab/curatedMetagenomicData)](https://codecov.io/gh/waldronlab/curatedMetagenomicData)
<!-- badges: end -->

The
*[curatedMetagenomicData](https://bioconductor.org/packages/3.24/curatedMetagenomicData)*
package provides standardized, curated human microbiome data for novel
analyses. It includes species relative abundance, marker abundance,
marker presence, Bracken species profiles and antimicrobial resistance
gene depth for samples collected from different body sites. Taxonomic
abundances for each sample were calculated with [MetaPhlAn
4](https://github.com/biobakery/MetaPhlAn) and
[Kraken2/Bracken](https://github.com/jenniferlu717/Bracken), and
resistance genes with
[KMA](https://bitbucket.org/genomicepidemiology/kma) against
[CARD](https://card.mcmaster.ca). The manually curated sample metadata
and standardized metagenomic data are available as
(Tree)SummarizedExperiment objects.

## What’s new in version 4

Version 4.0.0 reads its data from the public curatedMetagenomicData
releases at <https://cmgd-public.cancerdatasci.org> through the
[cmgdr](https://github.com/seandavi/cmgdr) package, instead of from
ExperimentHub. A release is an immutable, dated snapshot of one pipeline
registration; this version pins one, and `cmdRelease()` shows which. The
user-facing functions `curatedMetagenomicData()`, `returnSamples()` and
`mergeData()` keep their signatures and return types.

- **Metadata.** `sampleMetadata` is replaced by `harmonized_meta`
  (schema-aligned columns) and `all_meta` (plus study-specific columns
  still under harmonization).
- **Sample identity.** Objects are keyed by the release’s `sample_key`;
  curated metadata is joined to it by run accession. The `colData` holds
  the curated columns followed by the release’s per-sample QC columns.
- **Data types.** `relative_abundance`, `marker_abundance` and
  `marker_presence` continue; `bracken` and `resistome` are new. The
  HUMAnN data types (`gene_families`, `pathway_abundance`,
  `pathway_coverage`) return when the HUMAnN datasets are published.
- **Coverage.** The pinned release holds the studies processed so far by
  the new pipeline. Every study in the release is listed, whether or not
  it has curated metadata yet.

See `NEWS.md` for the full list of changes.

## Installation

To install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.24/curatedMetagenomicData)*
from Bioconductor, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r
BiocManager::install("curatedMetagenomicData")
```

To install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.24/curatedMetagenomicData)*
from GitHub, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r
BiocManager::install("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
```

Most users should simply install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.24/curatedMetagenomicData)*
from Bioconductor.

## Examples

To access curated metagenomic data, users will use the
`curatedMetagenomicData()` function both to query and return resources.
Multiple resources can be queried or returned with a single call to
`curatedMetagenomicData()`, but only the titles of resources are
returned by default.

``` r
curatedMetagenomicData("AsnicarF_20.+")
## 2026-10-20.AsnicarF_2017.relative_abundance
## 2026-10-20.AsnicarF_2017.marker_abundance
## 2026-10-20.AsnicarF_2017.marker_presence
## 2026-10-20.AsnicarF_2017.bracken
## 2026-10-20.AsnicarF_2017.resistome
```

When the `dryrun` argument is set to `FALSE`, a `list` of
`SummarizedExperiment` and/or `TreeSummarizedExperiment` objects is
returned. The `rownames` argument determines the type of `rownames` to
use for `relative_abundance` resources: either `"long"` (the default),
`"short"` (species name), or `"NCBI"` (NCBI Taxonomy ID). When a single
resource is requested, a single element `list` is returned.

``` r
curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, rownames = "short")
## $`2026-10-20.AsnicarF_2017.relative_abundance`
## class: TreeSummarizedExperiment 
## dim: 913 24 
## metadata(0):
## assays(1): relative_abundance
## rownames(913): Methanobrevibacter_smithii Methanosphaera_stadtmanae ...
##   Akkermansia_sp_BIOML_A66 Akkermansia_sp_N21116
## rowData names(8): superkingdom phylum ... species ncbi_taxid
## colnames(24): RS.1Lw9jFpaPHo3SFDkT4_dKIf2HMp4u3JK
##   RS.2RIKzrkv8vjM99hR46qeCXgaPB6_a6yB ...
##   RS.Zc57w716jKVKG_6UvW4UbrN3tlmQ_OXV
##   RS.ZGpyEvoNn4f_5wz0V7luDpdUHqqVgt4f
## colData names(34): study_name sample_id ... git_commit number_reads
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: NULL
## rowTree: NULL
## colLinks: NULL
## colTree: NULL
```

When the `counts` argument is set to `TRUE`, relative abundance
proportions are multiplied by read depth and rounded to the nearest
integer prior to being returned. Also, when multiple resources are
requested, the `list` will contain named elements corresponding to each
`SummarizedExperiment` and/or `TreeSummarizedExperiment` object.

``` r
curatedMetagenomicData("AsnicarF_20.+.relative_abundance", dryrun = FALSE, counts = TRUE, rownames = "short")
## $`2026-10-20.AsnicarF_2017.relative_abundance`
## class: TreeSummarizedExperiment 
## dim: 913 24 
## metadata(0):
## assays(1): relative_abundance
## rownames(913): Methanobrevibacter_smithii Methanosphaera_stadtmanae ...
##   Akkermansia_sp_BIOML_A66 Akkermansia_sp_N21116
## rowData names(8): superkingdom phylum ... species ncbi_taxid
## colnames(24): RS.1Lw9jFpaPHo3SFDkT4_dKIf2HMp4u3JK
##   RS.2RIKzrkv8vjM99hR46qeCXgaPB6_a6yB ...
##   RS.Zc57w716jKVKG_6UvW4UbrN3tlmQ_OXV
##   RS.ZGpyEvoNn4f_5wz0V7luDpdUHqqVgt4f
## colData names(34): study_name sample_id ... git_commit number_reads
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: NULL
## rowTree: NULL
## colLinks: NULL
## colTree: NULL
```

To return samples across studies, filter `harmonized_meta` and pass the
result to `returnSamples()`.

``` r
library(dplyr)

harmonized_meta |>
    filter(study_name %in% c("AsnicarF_2017", "ZellerG_2014")) |>
    filter(body_site == "feces") |>
    select(where(~ !all(is.na(.x)))) |>
    returnSamples("relative_abundance", rownames = "short")
## class: TreeSummarizedExperiment 
## dim: 1116 19 
## metadata(0):
## assays(1): relative_abundance
## rownames(1116): Methanobrevibacter_smithii Methanosphaera_stadtmanae
##   ... Saccharomyces_cerevisiae Blastocystis_sp_subtype_6
## rowData names(8): superkingdom phylum ... species ncbi_taxid
## colnames(19): RS.wP6CFlagMWIXNkQUF1QcOpF9tzS3SIZN
##   RS.m6yHjtU_3TiZGworEkrPrYczURQ9xngA ...
##   RS.8G5cd1ZeZW4RVHDQitQ1t5PV7IHCue2p
##   RS.bZz5VlfYIkTVYKmDibnmPtWb6pkLWBP9
## colData names(41): study_name sample_id ... git_commit number_reads
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: NULL
## rowTree: NULL
## colLinks: NULL
## colTree: NULL
```

## Analyses

See
[curatedMetagenomicAnalyses](https://github.com/waldronlab/curatedMetagenomicAnalyses)
for analyses in R and Python using
*[curatedMetagenomicData](https://bioconductor.org/packages/3.24/curatedMetagenomicData)*.

## Contributing

To contribute to the
*[curatedMetagenomicData](https://bioconductor.org/packages/3.24/curatedMetagenomicData)*
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
