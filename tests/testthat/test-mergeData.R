test_that("merge result is the equal to the first element of mergeList when its length == 1", {
    merge_list <-
        curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, counts = FALSE)

    expect_equal(mergeData(merge_list), merge_list[[1]])
})

test_that("merge result is the input itself when mergeList is a TreeSummarizedExperiment", {
    merge_list <-
        curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, counts = FALSE)

    tse <- merge_list[[1]]
    expect_s4_class(tse, "TreeSummarizedExperiment")
    expect_identical(mergeData(tse), tse)
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

test_that("assays merge over the union of row names with 0 for absent features", {
    a <- matrix(c(1, 2, 3, 4), 2, dimnames = list(c("f1", "f2"), c("s1", "s2")))
    b <- matrix(c(5, NA), 2, dimnames = list(c("f3", "f1"), "s3"))

    merged <- curatedMetagenomicData:::.merge_assays(list(a, b))

    expected <- matrix(
        c(1, 2, 0, 3, 4, 0, 0, 0, 5), 3,
        dimnames = list(c("f1", "f2", "f3"), c("s1", "s2", "s3"))
    )
    expect_identical(merged, expected)
})

test_that("merged assays stay integer, accept sparse input and empty studies", {
    a <- matrix(1:4, 2, dimnames = list(c("f1", "f2"), c("s1", "s2")))
    b <- matrix(5L, 1, dimnames = list("f3", "s3"))
    merged <- curatedMetagenomicData:::.merge_assays(list(a, b))
    expect_type(merged, "integer")
    expect_identical(merged[, "s3"], c(f1 = 0L, f2 = 0L, f3 = 5L))

    sparse <- Matrix::Matrix(a * 1, sparse = TRUE)
    empty <- b[, 0L, drop = FALSE]
    merged <- curatedMetagenomicData:::.merge_assays(list(sparse, empty, b * 1))
    expect_identical(dim(merged), c(3L, 3L))
    expect_identical(merged["f3", ], c(s1 = 0, s2 = 0, s3 = 5))
})

test_that("sparse assays merge to a sparse assay with the same values", {
    a <- matrix(c(1, 0, 3, 4), 2, dimnames = list(c("f1", "f2"), c("s1", "s2")))
    b <- matrix(c(5, NA, 0), 3, dimnames = list(c("f3", "f1", "f4"), "s3"))
    sparse <- list(
        Matrix::Matrix(a, sparse = TRUE),
        methods::as(Matrix::Matrix(b, sparse = TRUE), "TsparseMatrix"),
        Matrix::Matrix(b[, 0L, drop = FALSE], sparse = TRUE)
    )

    merged <- curatedMetagenomicData:::.merge_assays(sparse)

    expect_s4_class(merged, "dgCMatrix")
    expect_identical(
        as.matrix(merged),
        curatedMetagenomicData:::.merge_assays(list(a, b))
    )

    pattern <- methods::as(Matrix::Matrix(a != 0, sparse = TRUE), "nMatrix")
    merged <- curatedMetagenomicData:::.merge_assays(list(pattern, sparse[[2L]]))
    expect_identical(merged[, "s1"], c(f1 = 1, f2 = 0, f3 = 0, f4 = 0))
})

test_that("a sparse merge beyond 2^31 - 1 non-zero values stops with advice", {
    check <- curatedMetagenomicData:::.check_sparse_size
    expect_identical(check(c(2, 3), 2L), 5)
    expect_identical(check(rep(.Machine$integer.max, 1L), 1L), 2^31 - 1)
    ## integer counts must not overflow to NA when summed
    expect_error(
        check(rep(.Machine$integer.max, 2L), 5474L),
        "4,294,967,294 non-zero values from 5474 samples.*fewer samples"
    )
})

test_that("mergeData() checks the size of a sparse merge", {
    make_se <- function(samples) {
        SummarizedExperiment::SummarizedExperiment(
            assays = list(gene_families = Matrix::Matrix(
                matrix(1, 2L, length(samples), dimnames = list(c("f1", "f2"), samples)),
                sparse = TRUE
            )),
            colData = S4Vectors::DataFrame(study_name = rep("A", length(samples)), row.names = samples)
        )
    }
    testthat::local_mocked_bindings(
        .check_sparse_size = function(nnz, n_samples) {
            stop("checked ", sum(nnz), " values from ", n_samples, " samples")
        }
    )
    expect_error(
        mergeData(list(make_se("s1"), make_se(c("s2", "s3")))),
        "checked 6 values from 3 samples"
    )
})

test_that("mergeData() keeps gene_families-like sparse assays sparse", {
    study <- function(features, samples, name) {
        counts <- Matrix::Matrix(
            seq_len(length(features) * length(samples)) * 1,
            length(features), length(samples),
            dimnames = list(features, samples), sparse = TRUE
        )
        SummarizedExperiment::SummarizedExperiment(
            assays = list(gene_families = counts),
            colData = S4Vectors::DataFrame(study_name = rep(name, length(samples)), row.names = samples)
        )
    }

    merged <- mergeData(list(
        study(c("f1", "f2"), c("s1", "s2"), "A"),
        study(c("f2", "f3"), "s3", "B")
    ))

    expect_s4_class(assay(merged), "dgCMatrix")
    expect_identical(dim(merged), c(3L, 3L))
    expect_identical(assay(merged)["f2", ], c(s1 = 2, s2 = 4, s3 = 1))
    expect_identical(merged$study_name, c("A", "A", "B"))
})

test_that("mergeData() preserves rows when merging NCBI-keyed relative_abundance studies", {
    ns <- asNamespace("curatedMetagenomicData")
    pt <- ns[["phylogeneticTree"]]
    rd_ncbi <- ns[["rowDataNCBI"]]
    in_tree <- base::intersect(base::rownames(rd_ncbi), pt[["tip.label"]])
    rd_tree <- rd_ncbi[in_tree, ]
    dup_id <- base::unique(
        rd_tree[["species"]][base::duplicated(rd_tree[["species"]]) & !base::is.na(rd_tree[["species"]])]
    )[[1L]]
    dup_clades <- base::rownames(rd_tree)[!base::is.na(rd_tree[["species"]]) & rd_tree[["species"]] == dup_id]
    other_clades <- base::rownames(rd_tree)[!base::is.na(rd_tree[["species"]]) & rd_tree[["species"]] != dup_id][seq_len(3L)]
    keep_ranks <- c("superkingdom", "phylum", "class", "order", "family", "genus", "species")

    make_ncbi_tse <- function(clades, samples, study_name, merge_dups = TRUE) {
        mat <- base::matrix(
            base::seq_len(base::length(clades) * base::length(samples)) * 1,
            nrow = base::length(clades), ncol = base::length(samples),
            dimnames = list(clades, samples)
        )
        tse <- TreeSummarizedExperiment::TreeSummarizedExperiment(
            assays = S4Vectors::SimpleList(relative_abundance = mat),
            colData = S4Vectors::DataFrame(study_name = base::rep(study_name, base::length(samples)), row.names = samples),
            rowTree = pt
        )
        SummarizedExperiment::rowData(tse) <- rd_ncbi[clades, keep_ranks]
        species_id <- base::as.character(SummarizedExperiment::rowData(tse)[["species"]])
        if (merge_dups && base::anyDuplicated(species_id)) {
            summed <- base::rowsum(SummarizedExperiment::assay(tse), species_id, reorder = TRUE)
            tse <- tse[base::match(base::rownames(summed), species_id), ]
            SummarizedExperiment::assay(tse, withDimnames = FALSE) <- summed
            tse <- TreeSummarizedExperiment::subsetByLeaf(
                tse, rowLeaf = TreeSummarizedExperiment::rowLinks(tse)[["nodeLab"]]
            )
            pruned_tree <- TreeSummarizedExperiment::rowTree(tse)
            pruned_tree[["tip.label"]] <- base::rownames(summed)[base::match(
                pruned_tree[["tip.label"]],
                TreeSummarizedExperiment::rowLinks(tse)[["nodeLab"]]
            )]
            tse <- TreeSummarizedExperiment::changeTree(
                tse, rowTree = pruned_tree, rowNodeLab = base::rownames(summed)
            )
        }
        rownames(tse) <- base::as.character(SummarizedExperiment::rowData(tse)[["species"]])
        tse
    }

    study_a <- make_ncbi_tse(c(dup_clades, other_clades[c(1L, 2L)]), c("s1", "s2"), "StudyA")
    study_b <- make_ncbi_tse(c(dup_clades, other_clades[c(2L, 3L)]), c("s3", "s4"), "StudyB")
    study_c <- make_ncbi_tse(other_clades[c(1L, 3L)], "s5", "StudyC", merge_dups = FALSE)

    merged <- mergeData(list(study_a, study_b))
    expected_ids <- base::union(base::rownames(study_a), base::rownames(study_b))

    expect_s4_class(merged, "TreeSummarizedExperiment")
    expect_identical(base::nrow(merged), base::length(expected_ids))
    expect_setequal(base::rownames(merged), expected_ids)
    expect_true(base::all(TreeSummarizedExperiment::rowLinks(merged)[["isLeaf"]]))
    expect_equal(
        SummarizedExperiment::assay(merged)[base::rownames(study_a), c("s1", "s2")],
        SummarizedExperiment::assay(study_a)
    )
    expect_equal(
        SummarizedExperiment::assay(merged)[base::rownames(study_b), c("s3", "s4")],
        SummarizedExperiment::assay(study_b)
    )

    # Also works when combining a study with bare NCBI tip labels and one with clade tip labels
    merged_mixed <- mergeData(list(study_a, study_c))
    expect_identical(
        base::nrow(merged_mixed),
        base::length(base::union(base::rownames(study_a), base::rownames(study_c)))
    )
    expect_true(base::all(TreeSummarizedExperiment::rowLinks(merged_mixed)[["isLeaf"]]))
})
