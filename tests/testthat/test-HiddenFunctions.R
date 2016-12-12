context("HiddenFunctions")

test_that("load_suggest is not an exported function", {
    expect_error(load_suggests())
})

test_that("source_scripts is not an exported function", {
    expect_error(source_scripts())
})
