test_that("sampleMetadata data.frame is present", {
    expect_s3_class(sampleMetadata, "data.frame")
})

test_that("sampleMetadata dimensions have not decreased", {
    expect_gte(base::nrow(sampleMetadata), 31742)
    expect_gte(base::ncol(sampleMetadata), 202)
})

test_that("the harmonized attribute names columns of the table", {
    harmonized <- attr(sampleMetadata, "harmonized")
    expect_type(harmonized, "character")
    expect_gte(length(harmonized), 65)
    expect_true(all(harmonized %in% colnames(sampleMetadata)))
    expect_true(all(c("study_name", "sample_id", "ncbi_accession", "body_site") %in% harmonized))
})

test_that("study_name and sample_id identify a sample", {
    expect_false(anyDuplicated(paste(sampleMetadata$study_name, sampleMetadata$sample_id)) > 0L)
})

test_that("there are no columns of all NA values", {
    total_ncols <-
        base::ncol(sampleMetadata)

    not_na_ncols <-
        dplyr::select(sampleMetadata, where(~ !base::all(base::is.na(.x)))) |>
        base::ncol()

    expect_equal(total_ncols, not_na_ncols)
})
