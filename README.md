
<!-- README.md is generated from README.Rmd. Please edit that file -->

# curatedMetagenomicData

<!-- badges: start -->
<!-- badges: end -->

The curatedMetagenomicData package provides microbial taxonomic,
functional, and gene marker abundance for samples collected from
different body sites.

## Installation

You can install curatedMetagenomicData from Bioconductor with:

``` r
BiocManager::install("curatedMetagenomicData")
```

You can install curatedMetagenomicData from GitHub with:

``` r
BiocManager::install("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
```

You can install the last version of curatedMetagenomicData 1
([v1.20.0](https://github.com/waldronlab/curatedMetagenomicData/releases/tag/v1.20.0))
from GitHub with:

``` r
BiocManager::install("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE, ref = "v1.20.0")
```

## Examples

See the package vignette for more detailed examples.

``` r
library(curatedMetagenomicData)
```

``` r
curatedMetagenomicData("AsnicarF_2017")
#> 2021-03-31.AsnicarF_2017.gene_families
#> 2021-03-31.AsnicarF_2017.marker_abundance
#> 2021-03-31.AsnicarF_2017.marker_presence
#> 2021-03-31.AsnicarF_2017.pathway_abundance
#> 2021-03-31.AsnicarF_2017.pathway_coverage
#> 2021-03-31.AsnicarF_2017.relative_abundance
```

``` r
curatedMetagenomicData("AsnicarF_2017.relative_abundance")
#> 2021-03-31.AsnicarF_2017.relative_abundance
```

``` r
curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
#> snapshotDate(): 2021-04-27
#> $`2021-03-31.AsnicarF_2017.relative_abundance`
#> class: TreeSummarizedExperiment 
#> dim: 301 24 
#> metadata(0):
#> assays(1): relative_abundance
#> rownames(301):
#>   k__Bacteria|p__Proteobacteria|c__Gammaproteobacteria|o__Enterobacterales|f__Enterobacteriaceae|g__Escherichia|s__Escherichia_coli
#>   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Bifidobacteriales|f__Bifidobacteriaceae|g__Bifidobacterium|s__Bifidobacterium_bifidum
#>   ...
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Streptococcaceae|g__Streptococcus|s__Streptococcus_gordonii
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Aerococcaceae|g__Abiotrophia|s__Abiotrophia_sp_HMSC24B09
#> rowData names(0):
#> colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
#>   MV_MIM5_t3F15
#> colData names(20): studyName subjectID ... curator NCBI_accession
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (301 rows)
#> rowTree: 1 phylo tree(s) (10430 leaves)
#> colLinks: NULL
#> colTree: NULL
```

## Contributing

All are welcome to contribute to the curatedMetagenomicData project
provided contributions are appropriate. Please see the contributing
guide.

## Code of Conduct

Please note that the curatedMetagenomicData project is released with a
code of conduct. By contributing to this project, you agree to abide by
its terms.

------------------------------------------------------------------------

Pasolli E, Schiffer L, Manghi P, Renson A, Obenchain V, Truong D,
Beghini F, Malik F, Ramos M, Dowd J, Huttenhower C, Morgan M, Segata N,
Waldron L (2017). Accessible, curated metagenomic data through
ExperimentHub. *Nat. Methods*, **14**(11), 1023-1024. ISSN 1548-7091,
1548-7105, doi:
[10.1038/nmeth.4468](https://doi.org/10.1038/nmeth.4468).
