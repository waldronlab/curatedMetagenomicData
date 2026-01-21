# curatedMetagenomicData

The
*[curatedMetagenomicData](https://bioconductor.org/packages/3.23/curatedMetagenomicData)*
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
*[curatedMetagenomicData](https://bioconductor.org/packages/3.23/curatedMetagenomicData)*
from Bioconductor, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r

BiocManager::install("curatedMetagenomicData")
```

To install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.23/curatedMetagenomicData)*
from GitHub, use
*[BiocManager](https://CRAN.R-project.org/package=BiocManager)* as
follows.

``` r

BiocManager::install("waldronlab/curatedMetagenomicData", dependencies = TRUE, build_vignettes = TRUE)
```

Most users should simply install
*[curatedMetagenomicData](https://bioconductor.org/packages/3.23/curatedMetagenomicData)*
from Bioconductor.

## Examples

To access curated metagenomic data, users will use the
[`curatedMetagenomicData()`](https://waldronlab.io/curatedMetagenomicData/reference/curatedMetagenomicData.md)
method both to query and return resources. Multiple resources can be
queried or returned with a single call to
[`curatedMetagenomicData()`](https://waldronlab.io/curatedMetagenomicData/reference/curatedMetagenomicData.md),
but only the titles of resources are returned by default.

``` r

curatedMetagenomicData("AsnicarF_20.+")
## 2021-03-31.AsnicarF_2017.gene_families
## 2021-03-31.AsnicarF_2017.marker_abundance
## 2021-03-31.AsnicarF_2017.marker_presence
## 2021-03-31.AsnicarF_2017.pathway_abundance
## 2021-03-31.AsnicarF_2017.pathway_coverage
## 2021-03-31.AsnicarF_2017.relative_abundance
## 2021-10-14.AsnicarF_2017.gene_families
## 2021-10-14.AsnicarF_2017.marker_abundance
## 2021-10-14.AsnicarF_2017.marker_presence
## 2021-10-14.AsnicarF_2017.pathway_abundance
## 2021-10-14.AsnicarF_2017.pathway_coverage
## 2021-10-14.AsnicarF_2017.relative_abundance
## 2021-03-31.AsnicarF_2021.gene_families
## 2021-03-31.AsnicarF_2021.marker_abundance
## 2021-03-31.AsnicarF_2021.marker_presence
## 2021-03-31.AsnicarF_2021.pathway_abundance
## 2021-03-31.AsnicarF_2021.pathway_coverage
## 2021-03-31.AsnicarF_2021.relative_abundance
```

When the `dryrun` argument is set to `FALSE`, a `list` of
`SummarizedExperiment` and/or `TreeSummarizedExperiment` objects is
returned. The `rownames` argument determines the type of `rownames` to
use for `relative_abundance` resources: either `"long"` (the default),
`"short"` (species name), or `"NCBI"` (NCBI Taxonomy ID). When a single
resource is requested, a single element `list` is returned.

``` r

curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, rownames = "short")
## $`2021-10-14.AsnicarF_2017.relative_abundance`
## class: TreeSummarizedExperiment 
## dim: 298 24 
## metadata(0):
## assays(1): relative_abundance
## rownames(298): species:Escherichia coli species:Bifidobacterium bifidum
##   ... species:Streptococcus gordonii species:Abiotrophia sp. HMSC24B09
## rowData names(7): superkingdom phylum ... genus species
## colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
##   MV_MIM5_t3F15
## colData names(22): study_name subject_id ... pregnant lactating
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: a LinkDataFrame (298 rows)
## rowTree: 1 phylo tree(s) (10430 leaves)
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
## $`2021-10-14.AsnicarF_2017.relative_abundance`
## class: TreeSummarizedExperiment 
## dim: 298 24 
## metadata(0):
## assays(1): relative_abundance
## rownames(298): species:Escherichia coli species:Bifidobacterium bifidum
##   ... species:Streptococcus gordonii species:Abiotrophia sp. HMSC24B09
## rowData names(7): superkingdom phylum ... genus species
## colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
##   MV_MIM5_t3F15
## colData names(22): study_name subject_id ... pregnant lactating
## reducedDimNames(0):
## mainExpName: NULL
## altExpNames(0):
## rowLinks: a LinkDataFrame (298 rows)
## rowTree: 1 phylo tree(s) (10430 leaves)
## colLinks: NULL
## colTree: NULL
## 
## $`2021-03-31.AsnicarF_2021.relative_abundance`
## class: TreeSummarizedExperiment 
## dim: 639 1098 
## metadata(0):
## assays(1): relative_abundance
## rownames(639): species:Phocaeicola vulgatus species:Bacteroides
##   stercoris ... species:Pyramidobacter sp. C12-8 species:Brevibacterium
##   aurantiacum
## rowData names(7): superkingdom phylum ... genus species
## colnames(1098): SAMEA7041133 SAMEA7041134 ... SAMEA7045952 SAMEA7045953
## colData names(24): study_name subject_id ... BMI family
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
*[curatedMetagenomicData](https://bioconductor.org/packages/3.23/curatedMetagenomicData)*.

## Contributing

To contribute to the
*[curatedMetagenomicData](https://bioconductor.org/packages/3.23/curatedMetagenomicData)*
R/Bioconductor package, first read the [contributing
guidelines](https://waldronlab.io/curatedMetagenomicData/CONTRIBUTING.md)
and then open an issue. Also, note that in contributing you agree to
abide by the [code of
conduct](https://waldronlab.io/curatedMetagenomicData/CODE_OF_CONDUCT.md).

------------------------------------------------------------------------

Pasolli E, Schiffer L, Manghi P, Renson A, Obenchain V, Truong D,
Beghini F, Malik F, Ramos M, Dowd J, Huttenhower C, Morgan M, Segata N,
Waldron L (2017). Accessible, curated metagenomic data through
ExperimentHub. *Nat. Methods*, **14** (11), 1023-1024. ISSN 1548-7091,
1548-7105, doi:
[10.1038/nmeth.4468](https://doi.org/10.1038/nmeth.4468).
