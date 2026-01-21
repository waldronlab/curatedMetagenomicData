# Access Curated Metagenomic Data

To access curated metagenomic data users will use
`curatedMetagenomicData()` after "shopping" the
[sampleMetadata](https://waldronlab.io/curatedMetagenomicData/reference/sampleMetadata.md)
`data.frame` for resources they are interested in. The `dryrun` argument
allows users to perfect a query prior to returning resources. When
`dryrun = TRUE`, matched resources will be printed before they are
returned invisibly as a character vector. When `dryrun = FALSE`, a
`list` of resources containing
[SummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
and/or
[TreeSummarizedExperiment](https://rdrr.io/pkg/TreeSummarizedExperiment/man/TreeSummarizedExperiment-class.html)
objects, each with corresponding sample metadata, is returned. Multiple
resources can be returned simultaneously and if there is more than one
date corresponding to a resource, the most recent one is selected
automatically. Finally, if a `relative_abundance` resource is requested
and `counts = TRUE`, relative abundance proportions will be multiplied
by read depth and rounded to the nearest integer.

## Usage

``` r
curatedMetagenomicData(
  pattern,
  dryrun = TRUE,
  counts = FALSE,
  rownames = "long"
)
```

## Arguments

- pattern:

  regular expression pattern to look for in the titles of resources
  available in curatedMetagenomicData; `""` will return all resources

- dryrun:

  if `TRUE` (the default), a character vector of resource names is
  returned invisibly; if `FALSE`, a `list` of resources is returned

- counts:

  if `FALSE` (the default), relative abundance proportions are returned;
  if `TRUE`, relative abundance proportions are multiplied by read depth
  and rounded to the nearest integer prior to being returned

- rownames:

  the type of `rownames` to use for `relative_abundance` resources, one
  of: `"long"` (the default), `"short"` (species name), or `"NCBI"`
  (NCBI Taxonomy ID)

## Value

if `dryrun = TRUE`, a character vector of resource names is returned
invisibly; if `dryrun = FALSE`, a `list` of resources is returned

## Details

Above "resources" refers to resources that exists in Bioconductor's
ExperimentHub service. In the context of curatedMetagenomicData, these
are study-level (sparse) matrix objects used to create
[SummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
and/or
[TreeSummarizedExperiment](https://rdrr.io/pkg/TreeSummarizedExperiment/man/TreeSummarizedExperiment-class.html)
objects that are ultimately returned as the `list` of resources. Only
the `gene_families` `dataType` (see
[returnSamples](https://waldronlab.io/curatedMetagenomicData/reference/returnSamples.md))
is stored as a sparse matrix in ExperimentHub – this has no practical
consequences for users and is done to optimize storage. When searching
for "resources", users will use the `study_name` value from the
[sampleMetadata](https://waldronlab.io/curatedMetagenomicData/reference/sampleMetadata.md)
`data.frame`.

## See also

[mergeData](https://waldronlab.io/curatedMetagenomicData/reference/mergeData.md),
[returnSamples](https://waldronlab.io/curatedMetagenomicData/reference/returnSamples.md),
[sampleMetadata](https://waldronlab.io/curatedMetagenomicData/reference/sampleMetadata.md)

## Examples

``` r
curatedMetagenomicData("AsnicarF_20.+")
#> 2021-03-31.AsnicarF_2017.gene_families
#> 2021-03-31.AsnicarF_2017.marker_abundance
#> 2021-03-31.AsnicarF_2017.marker_presence
#> 2021-03-31.AsnicarF_2017.pathway_abundance
#> 2021-03-31.AsnicarF_2017.pathway_coverage
#> 2021-03-31.AsnicarF_2017.relative_abundance
#> 2021-10-14.AsnicarF_2017.gene_families
#> 2021-10-14.AsnicarF_2017.marker_abundance
#> 2021-10-14.AsnicarF_2017.marker_presence
#> 2021-10-14.AsnicarF_2017.pathway_abundance
#> 2021-10-14.AsnicarF_2017.pathway_coverage
#> 2021-10-14.AsnicarF_2017.relative_abundance
#> 2021-03-31.AsnicarF_2021.gene_families
#> 2021-03-31.AsnicarF_2021.marker_abundance
#> 2021-03-31.AsnicarF_2021.marker_presence
#> 2021-03-31.AsnicarF_2021.pathway_abundance
#> 2021-03-31.AsnicarF_2021.pathway_coverage
#> 2021-03-31.AsnicarF_2021.relative_abundance

curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
#> 
#> $`2021-10-14.AsnicarF_2017.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Enorma|s__[Collinsella]_massiliensis
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Carnobacteriaceae|g__Granulicatella|s__Granulicatella_elegans
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#>   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Cloacibacillus|s__Cloacibacillus_evryensis
#> $`2021-10-14.AsnicarF_2017.relative_abundance`
#> class: TreeSummarizedExperiment 
#> dim: 298 24 
#> metadata(0):
#> assays(1): relative_abundance
#> rownames(298):
#>   k__Bacteria|p__Proteobacteria|c__Gammaproteobacteria|o__Enterobacterales|f__Enterobacteriaceae|g__Escherichia|s__Escherichia_coli
#>   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Bifidobacteriales|f__Bifidobacteriaceae|g__Bifidobacterium|s__Bifidobacterium_bifidum
#>   ...
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Streptococcaceae|g__Streptococcus|s__Streptococcus_gordonii
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Aerococcaceae|g__Abiotrophia|s__Abiotrophia_sp_HMSC24B09
#> rowData names(7): superkingdom phylum ... genus species
#> colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
#>   MV_MIM5_t3F15
#> colData names(22): study_name subject_id ... pregnant lactating
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (298 rows)
#> rowTree: 1 phylo tree(s) (10430 leaves)
#> colLinks: NULL
#> colTree: NULL
#> 

curatedMetagenomicData("AsnicarF_20.+.relative_abundance", dryrun = FALSE, counts = TRUE)
#> 
#> $`2021-10-14.AsnicarF_2017.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Enorma|s__[Collinsella]_massiliensis
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Carnobacteriaceae|g__Granulicatella|s__Granulicatella_elegans
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#>   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Cloacibacillus|s__Cloacibacillus_evryensis
#> $`2021-03-31.AsnicarF_2021.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Enorma|s__[Collinsella]_massiliensis
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#>   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Cloacibacillus|s__Cloacibacillus_evryensis
#>   k__Eukaryota|p__Eukaryota_unclassified|c__Eukaryota_unclassified|o__Eukaryota_unclassified|f__Hexamitidae|g__Giardia|s__Giardia_intestinalis
#> $`2021-10-14.AsnicarF_2017.relative_abundance`
#> class: TreeSummarizedExperiment 
#> dim: 298 24 
#> metadata(0):
#> assays(1): relative_abundance
#> rownames(298):
#>   k__Bacteria|p__Proteobacteria|c__Gammaproteobacteria|o__Enterobacterales|f__Enterobacteriaceae|g__Escherichia|s__Escherichia_coli
#>   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Bifidobacteriales|f__Bifidobacteriaceae|g__Bifidobacterium|s__Bifidobacterium_bifidum
#>   ...
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Streptococcaceae|g__Streptococcus|s__Streptococcus_gordonii
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Aerococcaceae|g__Abiotrophia|s__Abiotrophia_sp_HMSC24B09
#> rowData names(7): superkingdom phylum ... genus species
#> colnames(24): MV_FEI1_t1Q14 MV_FEI2_t1Q14 ... MV_MIM5_t2M14
#>   MV_MIM5_t3F15
#> colData names(22): study_name subject_id ... pregnant lactating
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (298 rows)
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
#> rowData names(7): superkingdom phylum ... genus species
#> colnames(1098): SAMEA7041133 SAMEA7041134 ... SAMEA7045952 SAMEA7045953
#> colData names(24): study_name subject_id ... BMI family
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (639 rows)
#> rowTree: 1 phylo tree(s) (10430 leaves)
#> colLinks: NULL
#> colTree: NULL
#> 
```
