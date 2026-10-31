artacho <- function() {
    harmonized_meta |>
        dplyr::filter(study_name == "ArtachoA_2021") |>
        dplyr::select(where(~ !base::all(base::is.na(.x))))
}

test_that("study_name and sample_id must be present", {
    expect_error(returnSamples(dplyr::select(artacho(), -study_name), "relative_abundance"), "study_name")
    expect_error(returnSamples(dplyr::select(artacho(), -sample_id), "relative_abundance"), "sample_id")
    expect_error(returnSamples("not a data.frame", "relative_abundance"), "data.frame")
    expect_error(returnSamples(artacho()[0, ], "relative_abundance"), "no rows")
})

test_that("unknown and unpublished data types are rejected before any download", {
    expect_error(returnSamples(artacho(), "viral_clusters"), "unknown dataType")
    expect_error(returnSamples(artacho(), "gene_families"), "HUMAnN")
    expect_error(returnSamples(artacho(), "pathway_abundance"), "HUMAnN")
})

test_that("samples not in the release are dropped with a message", {
    skip_if_offline()
    sample_metadata <-
        artacho() |>
        dplyr::slice(1:6) |>
        dplyr::mutate(ncbi_accession = ifelse(dplyr::row_number() <= 2L, "SRR000000", ncbi_accession))

    expect_message(
        se <- returnSamples(sample_metadata, "resistome"),
        "dropping 2 sample"
    )
    expect_equal(ncol(se), 4L)
    expect_equal(se$sample_id, sample_metadata$sample_id[3:6])
})

test_that("studies absent from the release are reported", {
    skip_if_offline()
    not_there <- harmonized_meta |>
        dplyr::filter(study_name == "WindTT_2020") |>
        dplyr::slice(1:3)
    expect_error(returnSamples(not_there, "resistome"), "none of the studies")
})

test_that("colData is the input plus the release QC columns, in input order", {
    skip_if_offline()
    sample_metadata <-
        artacho() |>
        dplyr::arrange(dplyr::desc(sample_id)) |>
        dplyr::slice(1:10) |>
        dplyr::select(study_name, sample_id, age, sex, ncbi_accession)

    se <- returnSamples(sample_metadata, "resistome")

    col_data <- as.data.frame(SummarizedExperiment::colData(se))
    expect_equal(colnames(col_data)[1:5], colnames(sample_metadata))
    expect_equal(
        unname(as.list(col_data[, 1:5])),
        unname(as.list(as.data.frame(sample_metadata)))
    )
    expect_equal(rownames(col_data), col_data$sample_key)
    expect_equal(colnames(se), col_data$sample_key)
    expect_true(all(c("run_ids", "number_reads") %in% colnames(col_data)))
})

test_that("repeated rows are kept once and a DataFrame input is accepted", {
    skip_if_offline()
    sample_metadata <- dplyr::slice(artacho(), c(1:3, 1:3))
    expect_message(
        se <- returnSamples(S4Vectors::DataFrame(sample_metadata), "resistome"),
        "keeping 3 repeated"
    )
    expect_equal(ncol(se), 3L)
    expect_equal(se$sample_id, sample_metadata$sample_id[1:3])
})

test_that("the release QC columns replace input columns of the same name", {
    skip_if_offline()
    sample_metadata <-
        all_meta |>
        dplyr::filter(study_name == "ArtachoA_2021") |>
        dplyr::slice(1:3)
    skip_if_not("number_reads" %in% colnames(sample_metadata))

    tse <- returnSamples(sample_metadata, "relative_abundance", counts = TRUE)
    col_data <- SummarizedExperiment::colData(tse)
    expect_equal(sum(colnames(col_data) == "number_reads"), 1L)
    expect_equal(col_data$number_reads, as.numeric(col_data$reads_decontaminated))
    expect_false(anyNA(SummarizedExperiment::assay(tse)))
})

test_that("ncbi_accession is looked up when the caller dropped it", {
    skip_if_offline()
    sample_metadata <-
        artacho() |>
        dplyr::slice(1:5) |>
        dplyr::select(study_name, sample_id, age)

    se <- returnSamples(sample_metadata, "resistome")
    expect_equal(ncol(se), 5L)
    expect_equal(se$sample_id, sample_metadata$sample_id)
})

test_that("return type follows dataType and spans studies", {
    skip_if_offline()
    sample_metadata <-
        harmonized_meta |>
        dplyr::filter(study_name %in% c("ArtachoA_2021", "ZellerG_2014")) |>
        dplyr::select(where(~ !base::all(base::is.na(.x))))

    suppressMessages(
        tse <- returnSamples(sample_metadata, "relative_abundance", rownames = "short")
    )
    expect_s4_class(tse, "TreeSummarizedExperiment")
    expect_setequal(unique(tse$study_name), c("ArtachoA_2021", "ZellerG_2014"))
    expect_equal(ncol(tse), 69L + 3L)
    expect_false(any(grepl("\\|", rownames(tse))))

    suppressMessages(
        se <- returnSamples(sample_metadata, "bracken")
    )
    expect_s4_class(se, "SummarizedExperiment")
    expect_false(is(se, "TreeSummarizedExperiment"))
    expect_equal(colnames(se), colnames(tse))
})

test_that("counts = TRUE gives integers", {
    skip_if_offline()
    tse <- returnSamples(dplyr::slice(artacho(), 1:5), "relative_abundance", counts = TRUE)
    expect_true(is.integer(SummarizedExperiment::assay(tse)))
})
