test_that("harmonized_meta data.frame is present", {
    expect_s3_class(harmonized_meta, "data.frame")
})

test_that("all_meta data.frame is present", {
    expect_s3_class(all_meta, "data.frame")
})

test_that("harmonized_meta dimensions have not decreased", {
    expect_gte(base::nrow(harmonized_meta), 31742)
    expect_gte(base::ncol(harmonized_meta), 65)
})

test_that("all_meta has at least as many columns as harmonized_meta", {
    expect_equal(base::nrow(all_meta), base::nrow(harmonized_meta))
    expect_gte(base::ncol(all_meta), base::ncol(harmonized_meta))
})

test_that("harmonized_meta has no columns of all NA values", {
    total_ncols <-
        base::ncol(harmonized_meta)

    not_na_ncols <-
        dplyr::select(harmonized_meta, where(~ !base::all(base::is.na(.x)))) |>
        base::ncol()

    expect_equal(total_ncols, not_na_ncols)
})
