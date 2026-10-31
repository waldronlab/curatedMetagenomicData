test_that("cmdRelease() returns the pinned release and honours the options", {
    skip_if_offline()
    rel <- cmdRelease()
    expect_s3_class(rel, "cmgd_release")
    expect_equal(rel$dataset, "cmgd_mpa4.2-2.3.0")
    expect_equal(rel$release, "2026-10-20")

    first <- cmgdr::cmgd_releases(rel$dataset)$release[1L]
    withr::local_options(curatedMetagenomicData.release = first)
    expect_equal(cmdRelease()$release, first)
})

test_that("cmdRelease() caches the handle", {
    skip_if_offline()
    expect_identical(cmdRelease(), cmdRelease())
})
