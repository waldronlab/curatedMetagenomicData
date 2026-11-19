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

test_that("a sample_id shared by two studies is returned when requested from one", {
    # MH0001 and MH0002 are in both LeChatelierE_2013 and NielsenHB_2014
    requested <-
        dplyr::bind_rows(
            dplyr::filter(sampleMetadata, study_name == "LeChatelierE_2013", sample_id == "MH0001"),
            dplyr::filter(sampleMetadata, study_name == "NielsenHB_2014", sample_id == "MH0002")
        )

    returned <-
        suppressMessages(returnSamples(requested, "relative_abundance"))

    expect_identical(colnames(returned), c("MH0001", "MH0002"))
    expect_identical(returned$study_name, c("LeChatelierE_2013", "NielsenHB_2014"))
})

test_that("columns keep their own values when a requested sample is dropped", {
    zeller <-
        dplyr::filter(sampleMetadata, study_name == "ZellerG_2014") |>
        dplyr::slice(1)

    asnicar <-
        dplyr::filter(sampleMetadata, study_name == "AsnicarF_2017") |>
        dplyr::slice(1)

    absent <-
        dplyr::mutate(asnicar, sample_id = "not_a_sample")

    returned <-
        dplyr::bind_rows(zeller, absent, asnicar) |>
        returnSamples("relative_abundance") |>
        suppressMessages()

    whole_study <-
        curatedMetagenomicData("ZellerG_2014.relative_abundance", dryrun = FALSE) |>
        suppressMessages() |>
        magrittr::extract2(1L)

    species <-
        intersect(rownames(returned), rownames(whole_study))

    expect_identical(colnames(returned), c(zeller$sample_id, asnicar$sample_id))
    expect_identical(returned$study_name, c("ZellerG_2014", "AsnicarF_2017"))
    expect_equal(
        assay(returned)[species, zeller$sample_id],
        assay(whole_study)[species, zeller$sample_id]
    )
})
