test_that("you can't merge different data types.", {
    mergeList <- curatedMetagenomicData("AsnicarF_2017.marker_", dryrun = FALSE)
    expect_error(mergeData(mergeList))
})

test_that("merge results are correct.", {
    AsnicarF_2017 <- curatedMetagenomicData("AsnicarF_2017.marker_presence", dryrun = FALSE)[[1]]
    AsnicarF_2021 <- curatedMetagenomicData("AsnicarF_2021.marker_presence", dryrun = FALSE)[[1]]
    mergeList <- curatedMetagenomicData("AsnicarF_.+marker_presence", dryrun = FALSE)
    testData <- mergeData(mergeList)
    testData2017 <- testData[rownames(AsnicarF_2017), colnames(AsnicarF_2017)]
    testData2021 <- testData[rownames(AsnicarF_2021), colnames(AsnicarF_2021)]
    expect_equal(AsnicarF_2017, testData2017)
    expect_equal(AsnicarF_2021, testData2021)
})
