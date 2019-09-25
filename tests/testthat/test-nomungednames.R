context("no munged names")

## Change this to expect_error for Bioconductor 3.9,
## and remove the functions in Bioconductor >3.9.
test_that("Make defunct munged dataset names", {
    expect_error(Castro_NallarE_2015.metaphlan_bugs_list.oralcavity())
    expect_error(Heitz_BuschartA_2016.marker_presence.stool())
    expect_error(Obregon_TitoAJ_2015.metaphlan_bugs_list.stool())
})

## Make sure there are no other munged names
test_that("No underscores in dataset names", {
    allds <- curatedMetagenomicData("*", dryrun = TRUE)
    deprecation.regex <- "Castro_NallarE|Heitz_BuschartA|Obregon_TitoAJ|TettAJ_2019"
    allds <- grep(deprecation.regex, allds, invert = TRUE, value = TRUE)
    allnames <- sub("\\..+", "", allds)
    allnames <- sub("_2[0-9]{3}", "", allnames)
    invalid <- unique(grep("_", allnames, value = TRUE))
    msg <- paste0("Invalid dataset name: ", invalid)
    expect_true(all(!grepl("_", allnames)), info=msg)
})
