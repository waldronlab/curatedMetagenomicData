## Rebuild data/sampleMetadata.rda from the curation repository.
##
## Source of truth: curatedMetagenomicDataCuration::makeCombinedMetadata()
##   - makeCombinedMetadata()      -> the harmonized (data dictionary) columns
##   - makeCombinedMetadata(TRUE)  -> the same rows plus every other column
##
## sampleMetadata is the wide table; the names of the harmonized columns are
## kept in its "harmonized" attribute.

BiocManager::install("waldronlab/curatedMetagenomicDataCuration")

harmonized <-
    curatedMetagenomicDataCuration::makeCombinedMetadata() |>
    as.data.frame()

sampleMetadata <-
    curatedMetagenomicDataCuration::makeCombinedMetadata(TRUE) |>
    as.data.frame()

stopifnot(
    identical(harmonized, sampleMetadata[colnames(harmonized)]),
    !anyDuplicated(paste(sampleMetadata$study_name, sampleMetadata$sample_id))
)

## Drop columns that are empty everywhere.
empty <- vapply(sampleMetadata, function(x) all(is.na(x)), logical(1L))
sampleMetadata <- sampleMetadata[!empty]

attr(sampleMetadata, "harmonized") <- intersect(colnames(harmonized), colnames(sampleMetadata))

usethis::use_data(sampleMetadata, overwrite = TRUE, compress = "xz")
