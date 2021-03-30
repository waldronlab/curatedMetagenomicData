data(combined_metadata)

test_that("combined_metadata has dimensions greater or equal to 132 x 20400", {
    expect_gte(nrow(combined_metadata), 20400)
    expect_gte(ncol(combined_metadata), 132)
})

test_that("combined_metadata has dataset ZhuF_2020", {
    dataset <- combined_metadata[combined_metadata$dataset_name == "ZhuF_2020",]
    expect_gt(nrow(dataset), 0)
})

test_that("sample YSZC12003_35511's study_condition is asthma", {
    study <- combined_metadata[combined_metadata$sampleID == "YSZC12003_35511",]
    expect_equal(study$study_condition, "asthma")
})
