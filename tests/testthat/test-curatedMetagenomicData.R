# These tests read the pinned public release (see cmdRelease()) and need
# network access. ArtachoA_2021 (69 samples) is small enough to fetch in
# every test; the marker tables go through the release catalog and take
# longer, so only one test touches them.

test_that("pattern cannot be missing", {
    expect_error(curatedMetagenomicData(dryrun = TRUE, counts = FALSE))
    expect_error(curatedMetagenomicData(dryrun = FALSE, counts = FALSE))
})

test_that("fake resources do not exist", {
    skip_if_offline()
    expect_error(curatedMetagenomicData("SchifferL_2021", dryrun = TRUE, counts = FALSE))
})

test_that("every study in the release is listed with every data type", {
    skip_if_offline()
    titles <- curatedMetagenomicData(".+", dryrun = TRUE)
    rel <- cmdRelease()
    studies <- cmgdr::cmgd_studies(rel)[["study_name"]]
    parts <- strsplit(titles, ".", fixed = TRUE)
    expect_true(all(lengths(parts) == 3L))
    expect_setequal(vapply(parts, `[[`, character(1L), 1L), rel[["release"]])
    expect_setequal(vapply(parts, `[[`, character(1L), 2L), studies)
    expect_setequal(
        vapply(parts, `[[`, character(1L), 3L),
        c("relative_abundance", "marker_abundance", "marker_presence", "bracken", "resistome")
    )
    expect_length(titles, length(studies) * 5L)
})

test_that("return is invisible and character when `dryrun = TRUE`", {
    skip_if_offline()
    expect_invisible(curatedMetagenomicData("ArtachoA_2021", dryrun = TRUE))
    expect_type(curatedMetagenomicData("ArtachoA_2021", dryrun = TRUE), "character")
})

test_that("relative_abundance is a TreeSummarizedExperiment keyed by sample_key", {
    skip_if_offline()
    returned_resources <-
        curatedMetagenomicData("ArtachoA_2021.relative_abundance", dryrun = FALSE)

    expect_type(returned_resources, "list")
    expect_named(returned_resources, paste0(cmdRelease()[["release"]], ".ArtachoA_2021.relative_abundance"))

    tse <- returned_resources[[1L]]
    expect_s4_class(tse, "TreeSummarizedExperiment")
    expect_equal(SummarizedExperiment::assayNames(tse), "relative_abundance")
    expect_true(is.double(SummarizedExperiment::assay(tse)))
    expect_equal(ncol(tse), 69L)
    expect_true(all(startsWith(colnames(tse), "RS.")))
    expect_equal(colnames(tse), tse$sample_key)

    # rowData carries the parsed ranks and the NCBI id for every option
    expect_equal(
        colnames(SummarizedExperiment::rowData(tse)),
        c("superkingdom", "phylum", "class", "order", "family", "genus", "species", "ncbi_taxid")
    )
    expect_type(SummarizedExperiment::rowData(tse)[["ncbi_taxid"]], "integer")
    expect_true(all(grepl("\\|", rownames(tse))))

    # colData: curated columns first, then the release's QC columns
    col_data <- SummarizedExperiment::colData(tse)
    expect_equal(colnames(col_data)[1:2], c("study_name", "sample_id"))
    expect_true(all(c("sample_key", "run_ids", "reads_decontaminated", "number_reads") %in% colnames(col_data)))
    expect_equal(col_data[["number_reads"]], as.numeric(col_data[["reads_decontaminated"]]))
    expect_true(all(col_data[["study_name"]] == "ArtachoA_2021"))
})

test_that("colData matches sampleMetadata for the matched samples", {
    skip_if_offline()
    tse <-
        curatedMetagenomicData("ArtachoA_2021.relative_abundance", dryrun = FALSE)[[1L]]

    col_data <- as.data.frame(SummarizedExperiment::colData(tse))
    curated <- sampleMetadata[sampleMetadata$study_name == "ArtachoA_2021", ]
    curated <- curated[match(col_data$sample_id, curated$sample_id), ]

    expect_false(anyNA(col_data$sample_id))
    expect_equal(col_data$age, curated$age)
    expect_equal(col_data$sex, curated$sex)
    # every curated run accession is in the sample's run_ids
    expect_true(all(mapply(
        function(acc, runs) all(strsplit(acc, ";")[[1L]] %in% strsplit(runs, ";")[[1L]]),
        col_data$ncbi_accession, col_data$run_ids
    )))
    # curated columns that are all NA for the study are dropped (the QC
    # columns that follow sample_key are kept as published)
    curated_cols <- col_data[, seq_len(match("sample_key", colnames(col_data)) - 1L)]
    expect_false(any(vapply(curated_cols, function(x) all(is.na(x)), logical(1L))))
})

test_that("counts = TRUE gives integers scaled by number_reads", {
    skip_if_offline()
    tse <- curatedMetagenomicData("ArtachoA_2021.relative_abundance", dryrun = FALSE)[[1L]]
    counts <- curatedMetagenomicData("ArtachoA_2021.relative_abundance", dryrun = FALSE, counts = TRUE)[[1L]]

    expect_true(is.integer(SummarizedExperiment::assay(counts)))
    expected <- round(t(t(SummarizedExperiment::assay(tse)) * tse$number_reads / 100))
    storage.mode(expected) <- "integer"
    expect_equal(SummarizedExperiment::assay(counts), expected)
})

test_that('rownames = "short" gives species names', {
    skip_if_offline()
    tse <- curatedMetagenomicData("ArtachoA_2021.relative_abundance", dryrun = FALSE, rownames = "short")[[1L]]
    expect_false(any(grepl("\\|", rownames(tse))))
    expect_equal(rownames(tse), SummarizedExperiment::rowData(tse)[["species"]])
})

test_that('rownames = "NCBI" gives integer ids, dropping taxa without one', {
    skip_if_offline()
    long <- curatedMetagenomicData("ArtachoA_2021.relative_abundance", dryrun = FALSE)[[1L]]
    expect_warning(
        ncbi <- curatedMetagenomicData("ArtachoA_2021.relative_abundance", dryrun = FALSE, rownames = "NCBI")[[1L]],
        "no NCBI Taxonomy ID"
    )

    expect_false(any(grepl("[^0-9]", rownames(ncbi))))
    expect_false(anyDuplicated(rownames(ncbi)) > 0L)
    expect_equal(as.integer(rownames(ncbi)), SummarizedExperiment::rowData(ncbi)[["ncbi_taxid"]])
    expect_lt(nrow(ncbi), nrow(long))

    # the rows kept are exactly the rows of `long` with an id, summed by id
    has_id <- !is.na(SummarizedExperiment::rowData(long)[["ncbi_taxid"]])
    expect_equal(
        colSums(SummarizedExperiment::assay(ncbi)),
        colSums(SummarizedExperiment::assay(long)[has_id, ])
    )
})

test_that("bracken and resistome are SummarizedExperiments", {
    skip_if_offline()
    bracken <- curatedMetagenomicData("ArtachoA_2021.bracken", dryrun = FALSE)[[1L]]
    expect_s4_class(bracken, "SummarizedExperiment")
    expect_false(is(bracken, "TreeSummarizedExperiment"))
    expect_equal(SummarizedExperiment::assayNames(bracken), "bracken")
    expect_true(all(SummarizedExperiment::assay(bracken) >= 0 & SummarizedExperiment::assay(bracken) <= 1))
    expect_true(all(rowSums(SummarizedExperiment::assay(bracken)) > 0))
    expect_equal(colnames(SummarizedExperiment::rowData(bracken)), c("rank", "ncbi_taxid"))

    resistome <- curatedMetagenomicData("ArtachoA_2021.resistome", dryrun = FALSE)[[1L]]
    expect_s4_class(resistome, "SummarizedExperiment")
    expect_equal(SummarizedExperiment::assayNames(resistome), "resistome")
    expect_equal(colnames(resistome), colnames(bracken))
})

test_that("marker_presence comes from the release catalog", {
    skip_if_offline()
    skip_on_cran()
    se <- curatedMetagenomicData("ZellerG_2014.marker_presence", dryrun = FALSE)[[1L]]
    studies <- cmgdr::cmgd_studies(cmdRelease())
    expect_s4_class(se, "SummarizedExperiment")
    expect_equal(ncol(se), studies$n_samples[studies$study_name == "ZellerG_2014"])
    expect_true(all(SummarizedExperiment::assay(se) %in% c(0, 1)))
})

test_that("studies without curated metadata still return with QC colData", {
    skip_if_offline()
    rel <- cmdRelease()
    studies <- cmgdr::cmgd_studies(rel)
    uncurated <- setdiff(studies$study_name, sampleMetadata$study_name)
    skip_if(length(uncurated) == 0L, "every study in the release is curated")
    study <- uncurated[which.min(studies$n_samples[match(uncurated, studies$study_name)])]
    se <- curatedMetagenomicData(paste0(study, ".resistome"), dryrun = FALSE)[[1L]]
    expect_true(all(se$study_name == study))
    expect_true(all(c("sample_key", "run_ids", "number_reads") %in% colnames(SummarizedExperiment::colData(se))))
})
