test_that("age is the same after merge", {
    fm <- dplyr::filter(combined_metadata, age == 40, smoker == "yes", gender == "male")
    e <- returnSamples(fm, "marker_presence")
    sample1_fm <- dplyr::filter(fm, subject_id == "Travel006")$age
    sample2_fm <- dplyr::filter(fm, subject_id == "wHAXPI043593-9")$age
    sample1_cd <- colData(e)[colData(e)$subject_id == "Travel006", ]$age
    sample2_cd <- colData(e)[colData(e)$subject_id == "wHAXPI043593-9", ]$age
    expect_equal(sample1_fm, sample1_cd)
    expect_equal(sample2_fm, sample2_cd)
})
