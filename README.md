
<!-- README.md is generated from README.Rmd. Please edit that file -->

# curatedMetagenomicData

<!-- badges: start -->
<!-- badges: end -->

The curatedMetagenomicData package provides standardized, curated human
microbiome data for novel analyses. It includes gene families, marker
abundance, marker presence, pathway abundance, pathway coverage, and
relative abundance for samples collected from different body sites. The
bacterial, fungal, and archaeal taxonomic abundances for each sample
were calculated with MetaPhlAn3 and metabolic functional potential was
calculated with HUMAnN3. The manually curated sample metadata and
standardized metagenomic data are available as
(Tree)SummarizedExperiment objects.

## Versions

To avoid some confusion preemptively - there was *never* a version 2.0.0
of curatedMetagenomicData. Version 1.0.0 was released in 2017 and
version 3.0.0 was released in 2021; we skipped directly to version 3.0.0
to align with MetaPhlAn3 and HUMAnN3. Version 3.0.0 features significant
changes and, to be sure, they will take some adjustment. While users are
encouraged to upgrade to the latest (and greatest) version, the previous
version
([1.20.0](https://github.com/waldronlab/curatedMetagenomicData/releases/tag/v1.20.0))
of curatedMetagenomicData will remain installable for the foreseeable
future (see below). However, users should consider switching because
version 3.0.0 now uses the appropriate modern Bioconductor data
structures (`SummarizedExperiment` and `TreeSummarizedExperiment`). As
such, all of the previous version 1.0.0 methods that worked on
`ExpressionSet` objects are irrelevant and have moved directly to
defunct in version 3.0.0. Finally, to avoid additional confusion, the
resources pertaining to each release are only available in their
respective releases. It would be possible to access them with methods
from the `ExperimentHub` package, but doing so is strongly discouraged.

## Installation

You can install the current version of curatedMetagenomicData from
Bioconductor with:

``` r
BiocManager::install("curatedMetagenomicData")
```

You can install the current version of curatedMetagenomicData from
GitHub with:

``` r
BiocManager::install("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
```

You can install the previous version of curatedMetagenomicData from
GitHub with:

``` r
BiocManager::install("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE, ref = "v1.20.0")
```

## Examples

Find and access curated metagenomic data using
`curatedMetagenomicData()`:

``` r
library(curatedMetagenomicData)
```

``` r
curatedMetagenomicData("AsnicarF_20.+")
#> 2021-03-31.AsnicarF_2017.gene_families
#> 2021-03-31.AsnicarF_2017.marker_abundance
#> 2021-03-31.AsnicarF_2017.marker_presence
#> 2021-03-31.AsnicarF_2017.pathway_abundance
#> 2021-03-31.AsnicarF_2017.pathway_coverage
#> 2021-03-31.AsnicarF_2017.relative_abundance
#> 2021-03-31.AsnicarF_2021.gene_families
#> 2021-03-31.AsnicarF_2021.marker_abundance
#> 2021-03-31.AsnicarF_2021.marker_presence
#> 2021-03-31.AsnicarF_2021.pathway_abundance
#> 2021-03-31.AsnicarF_2021.pathway_coverage
#> 2021-03-31.AsnicarF_2021.relative_abundance
```

``` r
curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
#> snapshotDate(): 2021-05-05
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
#> rowData names(7): kingdom phylum ... genus species
#> colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
#>   MV_MIM5_t3F15
#> colData names(20): study_name subject_id ... lactating curator
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (301 rows)
#> rowTree: 1 phylo tree(s) (10430 leaves)
#> colLinks: NULL
#> colTree: NULL
```

``` r
curatedMetagenomicData("AsnicarF_20.+.relative_abundance", dryrun = FALSE, counts = TRUE)
#> snapshotDate(): 2021-05-05
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
#> rowData names(7): kingdom phylum ... genus species
#> colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
#>   MV_MIM5_t3F15
#> colData names(20): study_name subject_id ... lactating curator
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (301 rows)
#> rowTree: 1 phylo tree(s) (10430 leaves)
#> colLinks: NULL
#> colTree: NULL
#> 
#> $`2021-03-31.AsnicarF_2021.relative_abundance`
#> class: TreeSummarizedExperiment 
#> dim: 639 1098 
#> metadata(0):
#> assays(1): relative_abundance
#> rownames(639):
#>   k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Bacteroidaceae|g__Bacteroides|s__Bacteroides_vulgatus
#>   k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Bacteroidaceae|g__Bacteroides|s__Bacteroides_stercoris
#>   ...
#>   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Pyramidobacter|s__Pyramidobacter_sp_C12_8
#>   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Micrococcales|f__Brevibacteriaceae|g__Brevibacterium|s__Brevibacterium_aurantiacum
#> rowData names(7): kingdom phylum ... genus species
#> colnames(1098): SAMEA7041133 SAMEA7041134 ... SAMEA7045952 SAMEA7045953
#> colData names(20): study_name subject_id ... NCBI_accession curator
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (639 rows)
#> rowTree: 1 phylo tree(s) (10430 leaves)
#> colLinks: NULL
#> colTree: NULL
```

See the package vignette for more detailed examples.

## Contributing

All are welcome to contribute to the curatedMetagenomicData package
provided contributions are appropriate. Please see the contributing
guide.

## Code of Conduct

Please note that the curatedMetagenomicData package is released with a
code of conduct. By contributing, you agree to abide by its terms.

------------------------------------------------------------------------

Pasolli E, Schiffer L, Manghi P, Renson A, Obenchain V, Truong D,
Beghini F, Malik F, Ramos M, Dowd J, Huttenhower C, Morgan M, Segata N,
Waldron L (2017). Accessible, curated metagenomic data through
ExperimentHub. *Nat. Methods*, **14**(11), 1023-1024. ISSN 1548-7091,
1548-7105, doi:
[10.1038/nmeth.4468](https://doi.org/10.1038/nmeth.4468).
