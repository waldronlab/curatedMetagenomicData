# Two small studies of the pinned release: AsnicarF_2017 (24 samples) and
# ZellerG_2014 (3 samples).
two_studies <- "(AsnicarF_2017|ZellerG_2014)"

# Reorder an object's rows, columns and colData columns so two objects that
# hold the same data compare equal.
canonical <- function(x) {
    x <- x[sort(rownames(x)), sort(colnames(x))]
    col_data <- SummarizedExperiment::colData(x)
    col_data <- col_data[, sort(colnames(col_data)), drop = FALSE]
    col_data <- col_data[, vapply(col_data, function(v) !all(is.na(v)), logical(1L)), drop = FALSE]
    SummarizedExperiment::colData(x) <- col_data
    x
}

test_that("merge result is equal to the first element of mergeList when its length == 1", {
    skip_if_offline()
    merge_list <-
        curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)

    expect_equal(mergeData(merge_list), merge_list[[1]])
})

test_that("cannot merge list elements when dataType is different", {
    skip_if_offline()
    merge_list <-
        curatedMetagenomicData("ZellerG_2014.(bracken|resistome)", dryrun = FALSE)

    expect_error(mergeData(merge_list), "dataType")
})

test_that("merge keeps every study's values, filling absent features with 0", {
    skip_if_offline()
    merge_list <-
        curatedMetagenomicData(paste0(two_studies, ".resistome"), dryrun = FALSE)
    merged <- mergeData(merge_list)

    expect_s4_class(merged, "SummarizedExperiment")
    expect_false(is(merged, "TreeSummarizedExperiment"))
    expect_equal(ncol(merged), sum(vapply(merge_list, ncol, integer(1L))))
    expect_setequal(rownames(merged), unique(unlist(lapply(merge_list, rownames))))

    for (study in merge_list) {
        part <- merged[, colnames(study)]
        part <- part[rowSums(SummarizedExperiment::assay(part)) > 0, ]
        expect_equal(
            SummarizedExperiment::assay(canonical(part)),
            SummarizedExperiment::assay(canonical(study))
        )
        expect_equal(
            SummarizedExperiment::colData(canonical(part)),
            SummarizedExperiment::colData(canonical(study))
        )
    }
})

test_that("relative_abundance merges to a TreeSummarizedExperiment with rowData", {
    skip_if_offline()
    merge_list <-
        curatedMetagenomicData(paste0(two_studies, ".relative_abundance"), dryrun = FALSE)
    merged <- mergeData(merge_list)

    expect_s4_class(merged, "TreeSummarizedExperiment")
    expect_equal(
        colnames(SummarizedExperiment::rowData(merged)),
        colnames(SummarizedExperiment::rowData(merge_list[[1]]))
    )
    expect_setequal(unique(merged$study_name), c("AsnicarF_2017", "ZellerG_2014"))

    for (study in merge_list) {
        part <- merged[rownames(study), colnames(study)]
        expect_equal(
            SummarizedExperiment::assay(canonical(part)),
            SummarizedExperiment::assay(canonical(study))
        )
        expect_equal(
            SummarizedExperiment::rowData(canonical(part)),
            SummarizedExperiment::rowData(canonical(study))
        )
    }
})
