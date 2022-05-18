test_that("study_name must be present in sampleMetadata", {
    sample_metadata <-
        dplyr::filter(sampleMetadata, age >= 18) |>
        dplyr::filter(!base::is.na(alcohol)) |>
        dplyr::filter(body_site == "stool") |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        dplyr::select(-study_name)

    expect_error(returnSamples(sample_metadata, "relative_abundance"))
})

test_that("sample_id must be present in sampleMetadata", {
    sample_metadata <-
        dplyr::filter(sampleMetadata, age >= 18) |>
        dplyr::filter(!base::is.na(alcohol)) |>
        dplyr::filter(body_site == "stool") |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        dplyr::select(-sample_id)

    expect_error(returnSamples(sample_metadata, "relative_abundance"))
})

test_that("results have fewer samples than sampleMetadata when assay does not contain all samples", {
    sample_metadata <-
        dplyr::filter(sampleMetadata, study_name == "WindTT_2020") |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        dplyr::mutate(sample_id = base::paste(sample_id, "FAKE", sep = "_"))

    ncol_returned <-
        returnSamples(sample_metadata, "relative_abundance") |>
        base::ncol()

    nrow_metadata <-
        base::nrow(sample_metadata)

    expect_lt(ncol_returned, nrow_metadata)
})

test_that("message has an additional new line when dataType is not relative_abundance", {
    sample_metadata <-
        dplyr::filter(sampleMetadata, study_name == "WindTT_2020") |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        dplyr::mutate(sample_id = base::paste(sample_id, "FAKE", sep = "_"))

    expect_message(returnSamples(sample_metadata, "relative_abundance"), regexp = "^dropping columns without assay matches:\n")
    expect_message(returnSamples(sample_metadata, "pathway_coverage"), regexp = "^\ndropping columns without assay matches:\n")
})

test_that("sampleMetadata is equal to colData without sorting", {
    sample_metadata <-
        dplyr::filter(sampleMetadata, age >= 18) |>
        dplyr::filter(!base::is.na(alcohol)) |>
        dplyr::filter(body_site == "stool") |>
        dplyr::select(where(~ !base::all(base::is.na(.x))))

    col_data <-
        returnSamples(sample_metadata, "relative_abundance") |>
        SummarizedExperiment::colData() |>
        base::as.data.frame()

    sample_metadata <-
        tibble::column_to_rownames(sample_metadata, var = "sample_id")

    expect_equal(sample_metadata, col_data)
})

test_that("return type is SummarizedExperiment when dataType is not relative_abundance", {
    return_object <-
        dplyr::filter(sampleMetadata, age >= 18) |>
        dplyr::filter(!base::is.na(alcohol)) |>
        dplyr::filter(body_site == "stool") |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        returnSamples("marker_presence")

    expect_s4_class(return_object, "SummarizedExperiment")
})

test_that("return type is TreeSummarizedExperiment when dataType is relative_abundance", {
    return_object <-
        dplyr::filter(sampleMetadata, age >= 18) |>
        dplyr::filter(!base::is.na(alcohol)) |>
        dplyr::filter(body_site == "stool") |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        returnSamples("relative_abundance")

    expect_s4_class(return_object, "TreeSummarizedExperiment")
})
