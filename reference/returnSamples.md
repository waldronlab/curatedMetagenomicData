# Return Samples Across Studies

To return samples across studies, users will use `returnSamples()` along
with the
[sampleMetadata](https://waldronlab.io/curatedMetagenomicData/reference/sampleMetadata.md)
`data.frame` subset to include only desired samples and metadata. The
subset
[sampleMetadata](https://waldronlab.io/curatedMetagenomicData/reference/sampleMetadata.md)
`data.frame` will be used to get the desired resources,
[mergeData](https://waldronlab.io/curatedMetagenomicData/reference/mergeData.md)
will be used to merge them, and the subset
[sampleMetadata](https://waldronlab.io/curatedMetagenomicData/reference/sampleMetadata.md)
`data.frame` will be used again to subset the
[SummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
or
[TreeSummarizedExperiment](https://rdrr.io/pkg/TreeSummarizedExperiment/man/TreeSummarizedExperiment-class.html)
object to include only desired samples and metadata.

## Usage

``` r
returnSamples(sampleMetadata, dataType, counts = FALSE, rownames = "long")
```

## Arguments

- sampleMetadata:

  the
  [sampleMetadata](https://waldronlab.io/curatedMetagenomicData/reference/sampleMetadata.md)
  `data.frame` subset to include only desired samples and metadata

- dataType:

  the data type to be returned; one of the following:

  - `"gene_families"`

  - `"marker_abundance"`

  - `"marker_presence"`

  - `"pathway_abundance"`

  - `"pathway_coverage"`

  - `"relative_abundance"`

- counts:

  if `FALSE` (the default), relative abundance proportions are returned;
  if `TRUE`, relative abundance proportions are multiplied by read depth
  and rounded to the nearest integer prior to being returned

- rownames:

  the type of `rownames` to use for `relative_abundance` resources, one
  of: `"long"` (the default), `"short"` (species name), or `"NCBI"`
  (NCBI Taxonomy ID)

## Value

when `dataType = "relative_abundance"`, a
[TreeSummarizedExperiment](https://rdrr.io/pkg/TreeSummarizedExperiment/man/TreeSummarizedExperiment-class.html)
object is returned; otherwise, a
[SummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
object is returned

## Details

At present, curatedMetagenomicData resources exists only as entire
studies which requires potentially getting many resources for a limited
number of samples. Furthermore, because it is necessary to use
[mergeData](https://waldronlab.io/curatedMetagenomicData/reference/mergeData.md)
internally, the same caveats detailed under **Details** in
[mergeData](https://waldronlab.io/curatedMetagenomicData/reference/mergeData.md)
apply here.

## Examples

``` r
sampleMetadata |>
    dplyr::filter(age >= 18) |>
    dplyr::filter(!base::is.na(alcohol)) |>
    dplyr::filter(body_site == "stool") |>
    dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
    returnSamples("relative_abundance")
#> 
#> $`2021-10-14.KaurK_2020.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Atopobiaceae|g__Olsenella|s__Olsenella_profusa
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#> $`2021-03-31.KeohaneDM_2020.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Enorma|s__[Collinsella]_massiliensis
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#> $`2021-03-31.QinN_2014.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Atopobiaceae|g__Olsenella|s__Olsenella_profusa
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Enorma|s__[Collinsella]_massiliensis
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Bacillales|f__Bacillales_unclassified|g__Gemella|s__Gemella_bergeri
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Carnobacteriaceae|g__Granulicatella|s__Granulicatella_elegans
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Firmicutes|c__Erysipelotrichia|o__Erysipelotrichales|f__Erysipelotrichaceae|g__Bulleidia|s__Bulleidia_extructa
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#>   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Cloacibacillus|s__Cloacibacillus_evryensis
#> $`2021-03-31.ThomasAM_2018a.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Atopobiaceae|g__Olsenella|s__Olsenella_profusa
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Enorma|s__[Collinsella]_massiliensis
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Bacillales|f__Bacillales_unclassified|g__Gemella|s__Gemella_bergeri
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Carnobacteriaceae|g__Granulicatella|s__Granulicatella_elegans
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Firmicutes|c__Erysipelotrichia|o__Erysipelotrichales|f__Erysipelotrichaceae|g__Bulleidia|s__Bulleidia_extructa
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#>   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Cloacibacillus|s__Cloacibacillus_evryensis
#> $`2021-03-31.XieH_2016.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Atopobiaceae|g__Olsenella|s__Olsenella_profusa
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Enorma|s__[Collinsella]_massiliensis
#>   k__Bacteria|p__Firmicutes|c__Bacilli|o__Lactobacillales|f__Carnobacteriaceae|g__Granulicatella|s__Granulicatella_elegans
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Firmicutes|c__Erysipelotrichia|o__Erysipelotrichales|f__Erysipelotrichaceae|g__Bulleidia|s__Bulleidia_extructa
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#>   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Cloacibacillus|s__Cloacibacillus_evryensis
#> class: TreeSummarizedExperiment 
#> dim: 833 702 
#> metadata(0):
#> assays(1): relative_abundance
#> rownames(833):
#>   k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Prevotellaceae|g__Prevotella|s__Prevotella_copri
#>   k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Prevotellaceae|g__Prevotella|s__Prevotella_sp_CAG_520
#>   ...
#>   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Corynebacteriales|f__Corynebacteriaceae|g__Corynebacterium|s__Corynebacterium_aurimucosum
#>   k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Corynebacteriales|f__Corynebacteriaceae|g__Corynebacterium|s__Corynebacterium_coyleae
#> rowData names(7): superkingdom phylum ... genus species
#> colnames(702): JAS_1 JAS_10 ... YSZC12003_37879 YSZC12003_37880
#> colData names(48): study_name subject_id ...
#>   age_twins_started_to_live_apart zigosity
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (833 rows)
#> rowTree: 1 phylo tree(s) (10430 leaves)
#> colLinks: NULL
#> colTree: NULL
```
