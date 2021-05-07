test_that("returnSamples returns the same metadata passed to it", {
    filteredMetadata <-
        dplyr::filter(sampleMetadata, age == 40, smoker == "yes", gender == "male")

    result <-
        returnSamples(filteredMetadata, "marker_presence")

    expect_identical(base::colnames(result), filteredMetadata$sample_id)

    expect_identical(result$age, filteredMetadata$age)
})
