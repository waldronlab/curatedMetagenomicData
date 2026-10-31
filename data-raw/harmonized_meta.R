## Rebuild data/harmonized_meta.rda and data/all_meta.rda from staged
## copies of the harmonized cMD4 metadata.
##
## Source of truth: curatedMetagenomicDataCuration::makeCombinedMetadata()
##   - makeCombinedMetadata()       -> harmonized columns only
##   - makeCombinedMetadata(TRUE)   -> harmonized + under-harmonization columns
##
## Staged copies are shipped with this package at
##   inst/extdata/harmonized_meta.csv
##   inst/extdata/all_meta.csv
## so that rebuilding the .rda files (and the runtime package itself) does
## not require curatedMetagenomicDataCuration to be installed.
##
## To refresh the staged CSVs from the curation package, run:
##
##   harmonized_meta <- as.data.frame(
##       curatedMetagenomicDataCuration::makeCombinedMetadata())
##   all_meta        <- as.data.frame(
##       curatedMetagenomicDataCuration::makeCombinedMetadata(TRUE))
##   data.table::fwrite(harmonized_meta,
##                      "inst/extdata/harmonized_meta.csv", na = "")
##   data.table::fwrite(all_meta,
##                      "inst/extdata/all_meta.csv",        na = "")

read_staged <- function(name) {
    fpath <- system.file("extdata", name, package = "curatedMetagenomicData")
    if (!nzchar(fpath)) {
        fpath <- file.path("inst", "extdata", name)
    }
    readr::read_csv(
        fpath,
        na = c("", "NA"),
        show_col_types = FALSE,
        guess_max = 50000L
    ) |>
        as.data.frame()
}

harmonized_meta <- read_staged("harmonized_meta.csv")
all_meta        <- read_staged("all_meta.csv")

usethis::use_data(harmonized_meta, overwrite = TRUE)
usethis::use_data(all_meta,        overwrite = TRUE)
