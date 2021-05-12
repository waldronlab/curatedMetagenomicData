test_that("study_name must be present in sampleMetadata", {
    sample_metadata <-
        dplyr::filter(sampleMetadata, age >= 18) %>%
        dplyr::filter(!base::is.na(alcohol)) %>%
        dplyr::filter(body_site == "stool") %>%
        dplyr::select(where(~ !base::all(base::is.na(.x)))) %>%
        dplyr::select(-study_name)

    expect_error(returnSamples("relative_abundance"))
})

test_that("sample_id must be present in sampleMetadata", {
    sample_metadata <-
        dplyr::filter(sampleMetadata, age >= 18) %>%
        dplyr::filter(!base::is.na(alcohol)) %>%
        dplyr::filter(body_site == "stool") %>%
        dplyr::select(where(~ !base::all(base::is.na(.x)))) %>%
        dplyr::select(-sample_id)

    expect_error(returnSamples("relative_abundance"))
})

test_that("sampleMetadata is equal to colData without sorting", {
    sample_metadata <-
        dplyr::filter(sampleMetadata, age >= 18) %>%
        dplyr::filter(!base::is.na(alcohol)) %>%
        dplyr::filter(body_site == "stool") %>%
        dplyr::select(where(~ !base::all(base::is.na(.x))))

    col_data <-
        returnSamples(sample_metadata, "relative_abundance") %>%
        SummarizedExperiment::colData() %>%
        base::as.data.frame()

    sample_metadata <-
        tibble::column_to_rownames(sample_metadata, var = "sample_id")

    expect_equal(sample_metadata, col_data)
})

test_that("return type is SummarizedExperiment when dataType is not relative_abundance", {
    return_object <-
        dplyr::filter(sampleMetadata, age >= 18) %>%
        dplyr::filter(!base::is.na(alcohol)) %>%
        dplyr::filter(body_site == "stool") %>%
        dplyr::select(where(~ !base::all(base::is.na(.x)))) %>%
        returnSamples("marker_presence")

    expect_s4_class(return_object, "SummarizedExperiment")
})

test_that("return type is TreeSummarizedExperiment when dataType is relative_abundance", {
    return_object <-
        dplyr::filter(sampleMetadata, age >= 18) %>%
        dplyr::filter(!base::is.na(alcohol)) %>%
        dplyr::filter(body_site == "stool") %>%
        dplyr::select(where(~ !base::all(base::is.na(.x)))) %>%
        returnSamples("relative_abundance")

    expect_s4_class(return_object, "TreeSummarizedExperiment")
})
