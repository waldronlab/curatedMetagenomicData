context("cmdValidVersions")

test_that("inst/extdata/versions.txt provides valid versions", {
    vers <- cmdValidVersions()
    expect_true(.cmdIsValidVersion(vers))
})
