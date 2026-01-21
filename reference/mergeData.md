# Merge curatedMetagenomicData List

To merge the `list` elements returned from
[curatedMetagenomicData](https://waldronlab.io/curatedMetagenomicData/reference/curatedMetagenomicData.md)
into a single
[SummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
or
[TreeSummarizedExperiment](https://rdrr.io/pkg/TreeSummarizedExperiment/man/TreeSummarizedExperiment-class.html)
object, users will use `mergeData()` provided elements are the same
`dataType` (see
[returnSamples](https://waldronlab.io/curatedMetagenomicData/reference/returnSamples.md)).
This is useful for analysis across entire studies (e.g. meta-analysis);
however, when doing analysis across individual samples (e.g.
mega-analysis)
[returnSamples](https://waldronlab.io/curatedMetagenomicData/reference/returnSamples.md)
is preferable.

## Usage

``` r
mergeData(mergeList)
```

## Arguments

- mergeList:

  a `list` returned from
  [curatedMetagenomicData](https://waldronlab.io/curatedMetagenomicData/reference/curatedMetagenomicData.md)
  where all of the elements are of the same `dataType` (see
  [returnSamples](https://waldronlab.io/curatedMetagenomicData/reference/returnSamples.md))

## Value

when `mergeList` elements are of `dataType` (see
[returnSamples](https://waldronlab.io/curatedMetagenomicData/reference/returnSamples.md))
`relative_abundance`, a
[TreeSummarizedExperiment](https://rdrr.io/pkg/TreeSummarizedExperiment/man/TreeSummarizedExperiment-class.html)
object is returned; otherwise, a
[SummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
object is returned

## Details

Internally, `mergeData()` must full join `assays` and `rowData` slots of
each
[SummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
or
[TreeSummarizedExperiment](https://rdrr.io/pkg/TreeSummarizedExperiment/man/TreeSummarizedExperiment-class.html)
object (`colData` is merged slightly more efficiently by row binding).
While `dplyr` methods are used for maximum efficiency, users should be
aware that memory requirements can be large when merging many `list`
elements.

## See also

[curatedMetagenomicData](https://waldronlab.io/curatedMetagenomicData/reference/curatedMetagenomicData.md),
[returnSamples](https://waldronlab.io/curatedMetagenomicData/reference/returnSamples.md)

## Examples

``` r
curatedMetagenomicData("LiJ_20.+.marker_abundance", dryrun = FALSE) |>
    mergeData()
#> class: SummarizedExperiment 
#> dim: 77729 456 
#> metadata(0):
#> assays(1): marker_abundance
#> rownames(77729): 39491__A0A395UVM9__DXB76_04540
#>   39491__A0A395UZL1__DXB76_05950 ... 1262937__R7LHU6__BN805_01557
#>   712117__F3PBR4__HMPREF9056_02502
#> rowData names(0):
#> colnames(456): DLF005-IE DLM006-IE ... nHM612836 nHMX11726
#> colData names(28): study_name subject_id ... location smoker

curatedMetagenomicData("LiJ_20.+.pathway_abundance", dryrun = FALSE) |>
    mergeData()
#> class: SummarizedExperiment 
#> dim: 27110 456 
#> metadata(0):
#> assays(1): pathway_abundance
#> rownames(27110): UNMAPPED UNINTEGRATED ... PWY-7539:
#>   6-hydroxymethyl-dihydropterin diphosphate biosynthesis III
#>   (Chlamydia)|g__Prevotella.s__Prevotella_buccae LACTOSECAT-PWY:
#>   lactose and galactose degradation
#>   I|g__Escherichia.s__Escherichia_coli
#> rowData names(0):
#> colnames(456): DLF005-IE DLM006-IE ... nHM612836 nHMX11726
#> colData names(28): study_name subject_id ... location smoker

curatedMetagenomicData("LiJ_20.+.relative_abundance", dryrun = FALSE) |>
    mergeData()
#> 
#> $`2021-03-31.LiJ_2014.relative_abundance`
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
#> $`2021-10-14.LiJ_2017.relative_abundance`
#> dropping rows without rowTree matches:
#>   k__Bacteria|p__Actinobacteria|c__Coriobacteriia|o__Coriobacteriales|f__Coriobacteriaceae|g__Collinsella|s__Collinsella_stercoris
#>   k__Bacteria|p__Firmicutes|c__Clostridia|o__Clostridiales|f__Ruminococcaceae|g__Ruminococcus|s__Ruminococcus_champanellensis
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Burkholderiales|f__Sutterellaceae|g__Sutterella|s__Sutterella_parvirubra
#>   k__Bacteria|p__Synergistetes|c__Synergistia|o__Synergistales|f__Synergistaceae|g__Cloacibacillus|s__Cloacibacillus_evryensis
#> class: TreeSummarizedExperiment 
#> dim: 691 456 
#> metadata(0):
#> assays(1): relative_abundance
#> rownames(691):
#>   k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Bacteroidaceae|g__Bacteroides|s__Bacteroides_plebeius
#>   k__Bacteria|p__Bacteroidetes|c__Bacteroidia|o__Bacteroidales|f__Bacteroidaceae|g__Bacteroides|s__Bacteroides_caccae
#>   ...
#>   k__Bacteria|p__Proteobacteria|c__Betaproteobacteria|o__Neisseriales|f__Neisseriaceae|g__Neisseria|s__Neisseria_elongata
#>   k__Bacteria|p__Proteobacteria|c__Gammaproteobacteria|o__Enterobacterales|f__Morganellaceae|g__Providencia|s__Providencia_alcalifaciens
#> rowData names(7): superkingdom phylum ... genus species
#> colnames(456): DLF005-IE DLM006-IE ... nHM612836 nHMX11726
#> colData names(28): study_name subject_id ... location smoker
#> reducedDimNames(0):
#> mainExpName: NULL
#> altExpNames(0):
#> rowLinks: a LinkDataFrame (691 rows)
#> rowTree: 1 phylo tree(s) (10430 leaves)
#> colLinks: NULL
#> colTree: NULL
```
