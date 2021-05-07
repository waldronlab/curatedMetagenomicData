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

    colData(testData2017) <- colData(testData2017)[, colnames(colData(AsnicarF_2017))]
    colData(testData2021) <- colData(testData2021)[, colnames(colData(AsnicarF_2021))]

    expect_equal(assay(AsnicarF_2017), assay(testData2017))
    expect_equal(colData(AsnicarF_2017), colData(testData2017))
    expect_equal(rowData(AsnicarF_2017), rowData(testData2017))

    expect_equal(assay(AsnicarF_2021), assay(testData2021))
    expect_equal(colData(AsnicarF_2021), colData(testData2021))
    expect_equal(rowData(AsnicarF_2021), rowData(testData2021))

})

test_that("returnType is correct.", {

    marker_presence <- curatedMetagenomicData("AsnicarF_.+marker_presence", dryrun = FALSE)
    test_marker_presence <- mergeData(marker_presence)

    relative_abundance <- curatedMetagenomicData("AsnicarF_.+relative_abundance", dryrun = FALSE)
    test_relative_abundance <- mergeData(relative_abundance)

    expect_s4_class(test_marker_presence, "SummarizedExperiment")
    expect_s4_class(test_relative_abundance, "TreeSummarizedExperiment")

})
