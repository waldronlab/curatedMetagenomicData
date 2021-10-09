test_that("pattern cannot be missing", {
    expect_error(curatedMetagenomicData(dryrun = TRUE, counts = FALSE))
    expect_error(curatedMetagenomicData(dryrun = FALSE, counts = FALSE))
    expect_error(curatedMetagenomicData(dryrun = TRUE, counts = TRUE))
    expect_error(curatedMetagenomicData(dryrun = FALSE, counts = TRUE))
})

test_that("fake resources do not exists", {
    expect_error(curatedMetagenomicData("SchifferL_2021", dryrun = TRUE, counts = FALSE))
})

test_that("all metadata.csv resources exists", {
    metadata_file_path <-
        base::system.file("extdata/metadata.csv", package = "curatedMetagenomicData")

    if (!base::file.exists(metadata_file_path)) {
        metadata_file_path <-
            base::as.character("../../inst/extdata/metadata.csv")
    }

    metadata_resources <-
        readr::read_csv(metadata_file_path, col_types = "ccccccccclcccccc") |>
        dplyr::pull("Title") |>
        base::sort()

    returned_resources <-
        curatedMetagenomicData("", dryrun = TRUE, counts = FALSE) |>
        base::sort()

    expect_equal(metadata_resources, returned_resources)
})

test_that("return is invisible when `dryrun = TRUE`", {
    expect_invisible(curatedMetagenomicData("", dryrun = TRUE, counts = FALSE))
})

test_that("return type is character when `dryrun = TRUE`", {
    returned_resources <-
        curatedMetagenomicData("", dryrun = TRUE, counts = FALSE)

    expect_type(returned_resources, "character")
})

test_that("return type is list when `dryrun = FALSE`", {
    returned_resources <-
        curatedMetagenomicData("HMP_2012.marker_presence", dryrun = FALSE, counts = FALSE)

    expect_type(returned_resources, "list")
})

test_that("first list element is SummarizedExperiment when dataType is not relative_abundance", {
    returned_resources <-
        curatedMetagenomicData("HMP_2012.marker_presence", dryrun = FALSE, counts = FALSE)

    expect_s4_class(returned_resources[[1]], "SummarizedExperiment")
})

test_that("first list element is TreeSummarizedExperiment when dataType is relative_abundance", {
    returned_resources <-
        curatedMetagenomicData("HMP_2012.relative_abundance", dryrun = FALSE, counts = FALSE)

    expect_s4_class(returned_resources[[1]], "TreeSummarizedExperiment")
})

test_that("first assay matrix is all double numbers when dataType is relative_abundance and `counts = FLASE`", {
    returned_resources <-
        curatedMetagenomicData("HMP_2012.relative_abundance", dryrun = FALSE, counts = FALSE)

    all_double_numbers <-
        SummarizedExperiment::assay(returned_resources[[1]]) |>
        base::is.double()

    expect_true(all_double_numbers)
})

test_that("first assay matrix is all integer numbers when dataType is relative_abundance and `counts = TRUE`", {
    returned_resources <-
        curatedMetagenomicData("HMP_2012.relative_abundance", dryrun = FALSE, counts = TRUE)

    all_integer_numbers <-
        SummarizedExperiment::assay(returned_resources[[1]]) |>
        base::is.integer()

    expect_true(all_integer_numbers)
})

test_that("first list element colData matches sampleMetadata when dataType is not relative_abundance", {
    returned_resources <-
        curatedMetagenomicData("HMP_2012.marker_presence", dryrun = FALSE, counts = FALSE)

    resource_col_data <-
        SummarizedExperiment::colData(returned_resources[[1]]) |>
        base::as.data.frame() |>
        tibble::rownames_to_column(var = "sample_id")

    resource_col_names <-
        base::colnames(resource_col_data) |>
        base::sort()

    resource_col_data <-
        dplyr::select(resource_col_data, tidyselect::all_of(resource_col_names)) |>
        dplyr::arrange(sample_id)

    resource_study_name <-
        dplyr::pull(resource_col_data, "study_name") |>
        base::unique()

    sample_metadata_data_frame <-
        dplyr::filter(sampleMetadata, study_name == resource_study_name) |>
        dplyr::select(where(~ !base::all(base::is.na(.x))))

    sample_metadata_col_names <-
        base::colnames(sample_metadata_data_frame) |>
        base::sort()

    sample_metadata_data_frame <-
        dplyr::select(sample_metadata_data_frame, tidyselect::all_of(sample_metadata_col_names)) |>
        dplyr::arrange(sample_id)

    expect_equal(resource_col_data, sample_metadata_data_frame)
})

test_that("first list element colData matches sampleMetadata when dataType is relative_abundance", {
    returned_resources <-
        curatedMetagenomicData("HMP_2012.relative_abundance", dryrun = FALSE, counts = FALSE)

    resource_col_data <-
        SummarizedExperiment::colData(returned_resources[[1]]) |>
        base::as.data.frame() |>
        tibble::rownames_to_column(var = "sample_id")

    resource_col_names <-
        base::colnames(resource_col_data) |>
        base::sort()

    resource_col_data <-
        dplyr::select(resource_col_data, tidyselect::all_of(resource_col_names)) |>
        dplyr::arrange(sample_id)

    resource_study_name <-
        dplyr::pull(resource_col_data, "study_name") |>
        base::unique()

    sample_metadata_data_frame <-
        dplyr::filter(sampleMetadata, study_name == resource_study_name) |>
        dplyr::select(where(~ !base::all(base::is.na(.x))))

    sample_metadata_col_names <-
        base::colnames(sample_metadata_data_frame) |>
        base::sort()

    sample_metadata_data_frame <-
        dplyr::select(sample_metadata_data_frame, tidyselect::all_of(sample_metadata_col_names)) |>
        dplyr::arrange(sample_id)

    expect_equal(resource_col_data, sample_metadata_data_frame)
})
