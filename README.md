
<!-- README.md is generated from README.Rmd. Please edit that file -->

# curatedMetagenomicData

<!-- badges: start -->

[![code
quality](https://img.shields.io/codefactor/grade/github/waldronlab/curatedMetagenomicData)](https://www.codefactor.io/repository/github/waldronlab/curatedmetagenomicdata)
[![coverage](https://img.shields.io/codecov/c/github/waldronlab/curatedMetagenomicData)](https://codecov.io/gh/waldronlab/curatedMetagenomicData)
<!-- badges: end -->

The
*[curatedMetagenomicData](https://bioconductor.org/packages/3.14/curatedMetagenomicData)*
package provides standardized, curated human microbiome data for novel
analyses. It includes gene families, marker abundance, marker presence,
pathway abundance, pathway coverage, and relative abundance for samples
collected from different body sites. The bacterial, fungal, and archaeal
taxonomic abundances for each sample were calculated with
[MetaPhlAn3](https://github.com/biobakery/MetaPhlAn), and metabolic
functional potential was calculated with
[HUMAnN3](https://github.com/biobakery/humann). The manually curated
sample metadata and standardized metagenomic data are available as
(Tree)SummarizedExperiment objects.

## Installation

To install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.14/curatedMetagenomicData)*
from Bioconductor, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r
BiocManager::install("curatedMetagenomicData")
```

To install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.14/curatedMetagenomicData)*
from GitHub, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r
BiocManager::install("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
```

Most users should simply install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.14/curatedMetagenomicData)*
from Bioconductor.

## Examples

To access curated metagenomic data, users will use the
`curatedMetagenomicData()` method both to query and return resources.
Multiple resources can be queried or returned with a single call to
`curatedMetagenomicData()`, but only the titles of resources are
returned by default.

``` r
curatedMetagenomicData("AsnicarF_20.+")
## 2021-03-31.AsnicarF_2017.gene_families
## 2021-03-31.AsnicarF_2017.marker_abundance
## 2021-03-31.AsnicarF_2017.marker_presence
## 2021-03-31.AsnicarF_2017.pathway_abundance
## 2021-03-31.AsnicarF_2017.pathway_coverage
## 2021-03-31.AsnicarF_2017.relative_abundance
## 2021-03-31.AsnicarF_2021.gene_families
## 2021-03-31.AsnicarF_2021.marker_abundance
## 2021-03-31.AsnicarF_2021.marker_presence
## 2021-03-31.AsnicarF_2021.pathway_abundance
## 2021-03-31.AsnicarF_2021.pathway_coverage
## 2021-03-31.AsnicarF_2021.relative_abundance
```

When the second argument `dryrun` is set to `FALSE`, a `list` of
`SummarizedExperiment` and/or `TreeSummarizedExperiment` objects is
returned. When a single resource is requested, a single element `list`
is returned.

``` r
curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
## $`2021-03-31.AsnicarF_2017.relative_abundance`
## class: TreeSummarizedExperiment 
## dim: 301 24 
## metadata(0):
## assays(1): relative_abundance
## rownames(301):
##   k__Bacteria|p__Proteobacteria|c__Gammaproteobacteria|o__Enterobacterales|f__Enterobacteriaceae|g__Escherichia|s__Escherichia_coli
##   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Bifidobacteriales|f__Bifidobacteriaceae|g__Bifidobacterium|s__Bifidobacterium_bifidum
##   ...
##   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Streptococcaceae|g__Streptococcus|s__Streptococcus_gordonii
##   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Aerococcaceae|g__Abiotrophia|s__Abiotrophia_sp_HMSC24B09
## rowData names(7): Kingdom Phylum ... Genus Species
## colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
##   MV_MIM5_t3F15
## colData names(22): study_name subject_id ... lactating curator
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: a LinkDataFrame (301 rows)
## rowTree: 1 phylo tree(s) (10430 leaves)
## colLinks: NULL
## colTree: NULL
```

When the third argument `counts` is set to `TRUE`, relative abundance
proportions are multiplied by read depth and rounded to the nearest
integer prior to being returned. Also, when multiple resources are
requested, the `list` will contain named elements corresponding to each
`SummarizedExperiment` and/or `TreeSummarizedExperiment` object.

``` r
curatedMetagenomicData("AsnicarF_20.+.relative_abundance", dryrun = FALSE, counts = TRUE)
## $`2021-03-31.AsnicarF_2017.relative_abundance`
## class: TreeSummarizedExperiment 
## dim: 301 24 
## metadata(0):
## assays(1): relative_abundance
## rownames(301):
##   k__Bacteria|p__Proteobacteria|c__Gammaproteobacteria|o__Enterobacterales|f__Enterobacteriaceae|g__Escherichia|s__Escherichia_coli
##   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Bifidobacteriales|f__Bifidobacteriaceae|g__Bifidobacterium|s__Bifidobacterium_bifidum
##   ...
##   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Streptococcaceae|g__Streptococcus|s__Streptococcus_gordonii
##   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Aerococcaceae|g__Abiotrophia|s__Abiotrophia_sp_HMSC24B09
## rowData names(7): Kingdom Phylum ... Genus Species
## colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
##   MV_MIM5_t3F15
## colData names(22): study_name subject_id ... lactating curator
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: a LinkDataFrame (301 rows)
## rowTree: 1 phylo tree(s) (10430 leaves)
## colLinks: NULL
## colTree: NULL
## 
## $`2021-03-31.AsnicarF_2021.relative_abundance`
## class: TreeSummarizedExperiment 
## dim: 639 1098 
## metadata(0):
## assays(1): relative_abundance
## rownames(639):
##   k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Bacteroidaceae|g__Bacteroides|s__Bacteroides_vulgatus
##   k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Bacteroidaceae|g__Bacteroides|s__Bacteroides_stercoris
##   ...
##   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Pyramidobacter|s__Pyramidobacter_sp_C12_8
##   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Micrococcales|f__Brevibacteriaceae|g__Brevibacterium|s__Brevibacterium_aurantiacum
## rowData names(7): Kingdom Phylum ... Genus Species
## colnames(1098): SAMEA7041133 SAMEA7041134 ... SAMEA7045952 SAMEA7045953
## colData names(21): study_name subject_id ... curator BMI
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: a LinkDataFrame (639 rows)
## rowTree: 1 phylo tree(s) (10430 leaves)
## colLinks: NULL
## colTree: NULL
```

## Analyses

See
[curatedMetagenomicAnalyses](https://github.com/waldronlab/curatedMetagenomicAnalyses)
for analyses in R and Python using
*[curatedMetagenomicData](https://bioconductor.org/packages/3.14/curatedMetagenomicData)*.

## Contributing

To contribute to the
*[curatedMetagenomicData](https://bioconductor.org/packages/3.14/curatedMetagenomicData)*
R/Bioconductor package, first read the [contributing
guidelines](CONTRIBUTING.md) and then open an issue. Also note that in
contributing you agree to abide by the [code of
conduct](CODE_OF_CONDUCT.md).

------------------------------------------------------------------------

Pasolli E, Schiffer L, Manghi P, Renson A, Obenchain V, Truong D,
Beghini F, Malik F, Ramos M, Dowd J, Huttenhower C, Morgan M, Segata N,
Waldron L (2017). Accessible, curated metagenomic data through
ExperimentHub. *Nat. Methods*, **14** (11), 1023-1024. ISSN 1548-7091,
1548-7105, doi:
[10.1038/nmeth.4468](https://doi.org/10.1038/nmeth.4468).
