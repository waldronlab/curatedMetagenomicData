test_that("merge result is the equal to the first element of mergeList when its length == 1", {
    merge_list <-
        curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, counts = FALSE)

    expect_equal(mergeData(merge_list), merge_list[[1]])
})

test_that("cannot merge list elements when dataType is different", {
    merge_list <-
        curatedMetagenomicData("HMP_2012.marker_", dryrun = FALSE, counts = FALSE)

    expect_error(mergeData(merge_list))
})

test_that("duplicate column names are appended with study_name in output", {
    merge_list <-
        curatedMetagenomicData("(?:LeChatelierE_2013|NielsenHB_2014).relative_abundance", dryrun = FALSE, counts = FALSE)

    col_names <-
        purrr::map(merge_list, base::colnames) |>
        purrr::reduce(base::c)

    is_duplicated <-
        base::duplicated(col_names)

    duplicate_colnames <-
        magrittr::extract(col_names, is_duplicated)

    study_one_colnames <-
        base::paste(duplicate_colnames, "LeChatelierE_2013", sep = ".")

    study_two_colnames <-
        base::paste(duplicate_colnames, "NielsenHB_2014", sep = ".")

    merge_list_colnames <-
        mergeData(merge_list) |>
        base::colnames()

    expect_false(base::any(duplicate_colnames %in% merge_list_colnames))
    expect_true(base::all(study_one_colnames %in% merge_list_colnames))
    expect_true(base::all(study_two_colnames %in% merge_list_colnames))
})

test_that("merge result is correct when dataType is not relative_abundance", {
    merge_list <-
        curatedMetagenomicData("LiJ_20.+.marker_presence", dryrun = FALSE, counts = FALSE)

    study_one <-
        merge_list[[1]]

    row_order <-
        base::rownames(study_one) |>
        base::sort()

    col_order <-
        base::colnames(study_one) |>
        base::sort()

    study_one <-
        magrittr::extract(study_one, row_order, col_order)

    row_order <-
        SummarizedExperiment::colData(study_one) |>
        base::rownames()

    col_order <-
        SummarizedExperiment::colData(study_one) |>
        base::colnames() |>
        base::sort()

    SummarizedExperiment::colData(study_one) <-
        SummarizedExperiment::colData(study_one) |>
        magrittr::extract(row_order, col_order)

    study_two <-
        merge_list[[2]]

    row_order <-
        base::rownames(study_two) |>
        base::sort()

    col_order <-
        base::colnames(study_two) |>
        base::sort()

    study_two <-
        magrittr::extract(study_two, row_order, col_order)

    row_order <-
        SummarizedExperiment::colData(study_two) |>
        base::rownames()

    col_order <-
        SummarizedExperiment::colData(study_two) |>
        base::colnames() |>
        base::sort()

    SummarizedExperiment::colData(study_two) <-
        SummarizedExperiment::colData(study_two) |>
        magrittr::extract(row_order, col_order)

    study_name_one <-
        SummarizedExperiment::colData(study_one) |>
        base::as.data.frame() |>
        dplyr::pull("study_name") |>
        base::unique()

    study_name_two <-
        SummarizedExperiment::colData(study_two) |>
        base::as.data.frame() |>
        dplyr::pull("study_name") |>
        base::unique()

    merge_result <-
        mergeData(merge_list)

    merge_one <-
        SummarizedExperiment::subset(merge_result, select = study_name == study_name_one)

    keep_rows <-
        SummarizedExperiment::assay(merge_one) |>
        base::rowSums() |>
        magrittr::is_greater_than(0)

    keep_cols <-
        base::colnames(merge_one)

    merge_one <-
        magrittr::extract(merge_one, keep_rows, keep_cols)

    SummarizedExperiment::colData(merge_one) <-
        SummarizedExperiment::colData(merge_one) |>
        base::as.data.frame() |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        S4Vectors::DataFrame()

    row_order <-
        base::rownames(merge_one) |>
        base::sort()

    col_order <-
        base::colnames(merge_one) |>
        base::sort()

    merge_one <-
        magrittr::extract(merge_one, row_order, col_order)

    row_order <-
        SummarizedExperiment::colData(merge_one) |>
        base::rownames()

    col_order <-
        SummarizedExperiment::colData(merge_one) |>
        base::colnames() |>
        base::sort()

    SummarizedExperiment::colData(merge_one) <-
        SummarizedExperiment::colData(merge_one) |>
        magrittr::extract(row_order, col_order)

    merge_two <-
        SummarizedExperiment::subset(merge_result, select = study_name == study_name_two)

    keep_rows <-
        SummarizedExperiment::assay(merge_two) |>
        base::rowSums() |>
        magrittr::is_greater_than(0)

    keep_cols <-
        base::colnames(merge_two)

    merge_two <-
        magrittr::extract(merge_two, keep_rows, keep_cols)

    SummarizedExperiment::colData(merge_two) <-
        SummarizedExperiment::colData(merge_two) |>
        base::as.data.frame() |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        S4Vectors::DataFrame()

    row_order <-
        base::rownames(merge_two) |>
        base::sort()

    col_order <-
        base::colnames(merge_two) |>
        base::sort()

    merge_two <-
        magrittr::extract(merge_two, row_order, col_order)

    row_order <-
        SummarizedExperiment::colData(merge_two) |>
        base::rownames()

    col_order <-
        SummarizedExperiment::colData(merge_two) |>
        base::colnames() |>
        base::sort()

    SummarizedExperiment::colData(merge_two) <-
        SummarizedExperiment::colData(merge_two) |>
        magrittr::extract(row_order, col_order)

    expect_equal(SummarizedExperiment::assay(study_one), SummarizedExperiment::assay(merge_one))
    expect_equal(SummarizedExperiment::colData(study_one), SummarizedExperiment::colData(merge_one))
    expect_equal(SummarizedExperiment::rowData(study_one), SummarizedExperiment::rowData(merge_one))

    expect_equal(SummarizedExperiment::assay(study_two), SummarizedExperiment::assay(merge_two))
    expect_equal(SummarizedExperiment::colData(study_two), SummarizedExperiment::colData(merge_two))
    expect_equal(SummarizedExperiment::rowData(study_two), SummarizedExperiment::rowData(merge_two))
})

test_that("merge result is correct when dataType is relative_abundance", {
    merge_list <-
        curatedMetagenomicData("LiJ_20.+.relative_abundance", dryrun = FALSE, counts = FALSE)

    study_one <-
        merge_list[[1]]

    row_order <-
        base::rownames(study_one) |>
        base::sort()

    col_order <-
        base::colnames(study_one) |>
        base::sort()

    study_one <-
        magrittr::extract(study_one, row_order, col_order)

    row_order <-
        SummarizedExperiment::colData(study_one) |>
        base::rownames()

    col_order <-
        SummarizedExperiment::colData(study_one) |>
        base::colnames() |>
        base::sort()

    SummarizedExperiment::colData(study_one) <-
        SummarizedExperiment::colData(study_one) |>
        magrittr::extract(row_order, col_order)

    study_two <-
        merge_list[[2]]

    row_order <-
        base::rownames(study_two) |>
        base::sort()

    col_order <-
        base::colnames(study_two) |>
        base::sort()

    study_two <-
        magrittr::extract(study_two, row_order, col_order)

    row_order <-
        SummarizedExperiment::colData(study_two) |>
        base::rownames()

    col_order <-
        SummarizedExperiment::colData(study_two) |>
        base::colnames() |>
        base::sort()

    SummarizedExperiment::colData(study_two) <-
        SummarizedExperiment::colData(study_two) |>
        magrittr::extract(row_order, col_order)

    study_name_one <-
        SummarizedExperiment::colData(study_one) |>
        base::as.data.frame() |>
        dplyr::pull("study_name") |>
        base::unique()

    study_name_two <-
        SummarizedExperiment::colData(study_two) |>
        base::as.data.frame() |>
        dplyr::pull("study_name") |>
        base::unique()

    merge_result <-
        mergeData(merge_list)

    merge_one <-
        SummarizedExperiment::subset(merge_result, select = study_name == study_name_one)

    keep_rows <-
        SummarizedExperiment::assay(merge_one) |>
        base::rowSums() |>
        magrittr::is_greater_than(0)

    keep_cols <-
        base::colnames(merge_one)

    merge_one <-
        magrittr::extract(merge_one, keep_rows, keep_cols)

    SummarizedExperiment::colData(merge_one) <-
        SummarizedExperiment::colData(merge_one) |>
        base::as.data.frame() |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        S4Vectors::DataFrame()

    row_order <-
        base::rownames(merge_one) |>
        base::sort()

    col_order <-
        base::colnames(merge_one) |>
        base::sort()

    merge_one <-
        magrittr::extract(merge_one, row_order, col_order)

    row_order <-
        SummarizedExperiment::colData(merge_one) |>
        base::rownames()

    col_order <-
        SummarizedExperiment::colData(merge_one) |>
        base::colnames() |>
        base::sort()

    SummarizedExperiment::colData(merge_one) <-
        SummarizedExperiment::colData(merge_one) |>
        magrittr::extract(row_order, col_order)

    merge_two <-
        SummarizedExperiment::subset(merge_result, select = study_name == study_name_two)

    keep_rows <-
        SummarizedExperiment::assay(merge_two) |>
        base::rowSums() |>
        magrittr::is_greater_than(0)

    keep_cols <-
        base::colnames(merge_two)

    merge_two <-
        magrittr::extract(merge_two, keep_rows, keep_cols)

    SummarizedExperiment::colData(merge_two) <-
        SummarizedExperiment::colData(merge_two) |>
        base::as.data.frame() |>
        dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
        S4Vectors::DataFrame()

    row_order <-
        base::rownames(merge_two) |>
        base::sort()

    col_order <-
        base::colnames(merge_two) |>
        base::sort()

    merge_two <-
        magrittr::extract(merge_two, row_order, col_order)

    row_order <-
        SummarizedExperiment::colData(merge_two) |>
        base::rownames()

    col_order <-
        SummarizedExperiment::colData(merge_two) |>
        base::colnames() |>
        base::sort()

    SummarizedExperiment::colData(merge_two) <-
        SummarizedExperiment::colData(merge_two) |>
        magrittr::extract(row_order, col_order)

    expect_equal(SummarizedExperiment::assay(study_one), SummarizedExperiment::assay(merge_one))
    expect_equal(SummarizedExperiment::colData(study_one), SummarizedExperiment::colData(merge_one))
    expect_equal(SummarizedExperiment::rowData(study_one), SummarizedExperiment::rowData(merge_one))

    expect_equal(SummarizedExperiment::assay(study_two), SummarizedExperiment::assay(merge_two))
    expect_equal(SummarizedExperiment::colData(study_two), SummarizedExperiment::colData(merge_two))
    expect_equal(SummarizedExperiment::rowData(study_two), SummarizedExperiment::rowData(merge_two))
})

test_that("return type is SummarizedExperiment when dataType is not relative_abundance", {
    merge_result <-
        curatedMetagenomicData("LiJ_20.+.marker_presence", dryrun = FALSE, counts = FALSE) |>
        mergeData()

    expect_s4_class(merge_result, "SummarizedExperiment")
})

test_that("return type is TreeSummarizedExperiment when dataType is relative_abundance", {
    merge_result <-
        curatedMetagenomicData("LiJ_20.+.relative_abundance", dryrun = FALSE, counts = FALSE) |>
        mergeData()

    expect_s4_class(merge_result, "TreeSummarizedExperiment")
})
