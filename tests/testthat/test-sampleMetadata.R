BiocManager::install("waldronlab/curatedMetagenomicDataCuration")

data("sampleMetadata", "combined_metadata")

test_that("all studies from cMD (metadata file) are in sampleMetadata", {

    expectedStudyNames <- system.file("extdata/metadata.csv", package = "curatedMetagenomicData") %>%
        read.csv() %>%
        .[["Title"]] %>%
        sub("^.+\\.(.+)\\..+$", "\\1", .) %>%
        unique() %>%
        sort()

    testStudyNames <- sampleMetadata[["study_name"]] %>%
        unique() %>%
        sort()

    expect_identical(testStudyNames, expectedStudyNames)

})

test_that("all required columns are present in sampleMetadata", {

    requiredColumns <- system.file("extdata/template.csv", package = "curatedMetagenomicDataCuration") %>%
        read.csv() %>%
        subset(requiredness == "required") %>%
        .[["col.name"]]

    expect_true(all(requiredColumns %in% colnames(sampleMetadata)))

})

test_that("combined_metadata and sampleMetadata are the same", {

    expect_identical(combined_metadata, sampleMetadata)

})
