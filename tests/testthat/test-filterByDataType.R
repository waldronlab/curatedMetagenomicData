test_that("filterByDataType returns the same filtered data passed to it", {
    filteredMetadata <- dplyr::filter(sampleMetadata, age == 40,
                                      smoker == "yes", gender == "male")
    result <- filterByDataType(filteredMetadata, "marker_presence")
    expect_identical(colnames(result), filteredMetadata$sampleID)
    expect_identical(result$age, filteredMetadata$age)
})
