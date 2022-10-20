test_that("sampleMetadata data.frame is present", {
    expect_s3_class(sampleMetadata, "data.frame")
})

test_that("sampleMetadata dimensions have not decreased", {
    expect_gte(base::nrow(sampleMetadata), 22588)
    expect_gte(base::ncol(sampleMetadata), 148)
})

test_that("there are no columns of all NA values", {
    total_ncols <-
        base::ncol(sampleMetadata)

    not_na_ncols <-
        dplyr::select(sampleMetadata, where(~ !base::all(base::is.na(.x)))) |>
        base::ncol()

    expect_equal(total_ncols, not_na_ncols)
})
