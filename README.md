
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

## Command-line installation

You must first install the R package, see instructions above. Then you
can place the command-line tool on your path as follows:

    CMDLIB=$(R -e 'find.package("curatedMetagenomicData")' | grep -o -e "/.*\w")/commandline
    echo -e "export PATH=\$PATH:$CMDLIB" >> ~/.bashrc
    chmod +x $CMDLIB/curatedMetagenomicData

### Command-line usage

    Usage:
      curatedMetagenomicData [--metadata] [--counts] [--dryrun] [<NAME>]...
      curatedMetagenomicData [-mcd] [<NAME>]...
      curatedMetagenomicData -l | --list
      curatedMetagenomicData -h | --help

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
#> class: SummarizedExperiment 
#> dim: 550 24 
#> metadata(0):
#> assays(1): relative_abundance
#> rownames(550): k__Bacteria k__Bacteria|p__Proteobacteria ...
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Streptococcaceae|g__Streptococcus|s__Streptococcus_gordonii
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Aerococcaceae|g__Abiotrophia|s__Abiotrophia_sp_HMSC24B09
#> rowData names(0):
#> colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
#>   MV_MIM5_t3F15
#> colData names(20): studyName subjectID ... curator NCBI_accession
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
