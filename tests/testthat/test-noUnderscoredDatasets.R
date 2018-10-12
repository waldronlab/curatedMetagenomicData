context("curatedMetagenomicData")

test_that("No underscores in dataset names", {
    allds <- curatedMetagenomicData("*", dryrun = TRUE)
    allnames <- sub("\\..+", "", allds)
    allnames <- sub("_2[0-9]{3}", "", allnames)
    invalid <- unique(grep("_", allnames, value = TRUE))
    msg <- paste0("Invalid dataset name: ", invalid)
    expect_true(all(!grepl("_", allnames)), info=msg)
})
