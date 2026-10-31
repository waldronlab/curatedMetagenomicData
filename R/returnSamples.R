#' Return Samples Across Studies
#'
#' To return samples across studies, users will use `returnSamples()` along with
#' the [harmonized_meta] `data.frame` subset to include only desired samples and
#' metadata. The subset `data.frame` is matched to the samples of the release
#' in use (see [cmdRelease]), their profiles are read and merged, and the subset
#' `data.frame` becomes the `colData` of the
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class] or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object that is returned.
#'
#' Curated samples are matched to the release by run accession
#' (`ncbi_accession` in [harmonized_meta] against the release's `run_ids`).
#' Samples that are not in the release, or whose accessions match no single
#' sample, are dropped with a message naming them; a sample given more than
#' once is kept once. The returned object's columns are named by the
#' release's `sample_key`; the `colData` holds the input columns followed by
#' the release's per-sample QC columns (`sample_key`, `run_ids`,
#' `number_reads`, ...), which replace any input columns of the same name.
#'
#' @param sampleMetadata the [harmonized_meta] `data.frame` subset to include
#' only desired samples and metadata; `study_name` and `sample_id` must be
#' present
#'
#' @param dataType the data type to be returned; one of the following (see the
#' Data types section of [curatedMetagenomicData]):
#' * `"relative_abundance"`
#' * `"marker_abundance"`
#' * `"marker_presence"`
#' * `"bracken"`
#' * `"resistome"`
#'
#' @param counts if `FALSE` (the default), relative abundance proportions are
#' returned; if `TRUE`, relative abundance proportions are multiplied by read
#' depth and rounded to the nearest integer prior to being returned
#'
#' @param rownames the type of `rownames` to use for `relative_abundance`
#' resources, one of: `"long"` (the default, the full MetaPhlAn clade string),
#' `"short"` (species name), or `"NCBI"` (NCBI Taxonomy ID); see the
#' Taxonomic names section of [curatedMetagenomicData]
#'
#' @return when `dataType = "relative_abundance"`, a
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' object is returned; otherwise, a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' object is returned
#' @export
#'
#' @seealso [curatedMetagenomicData], [mergeData], [harmonized_meta]
#'
#' @examples
#' harmonized_meta |>
#'     dplyr::filter(study_name %in% c("AsnicarF_2017", "ZellerG_2014")) |>
#'     dplyr::filter(age_years >= 18) |>
#'     dplyr::filter(body_site == "feces") |>
#'     dplyr::select(where(~ !base::all(base::is.na(.x)))) |>
#'     returnSamples("relative_abundance")
#'
#' @importFrom stringr str_c
#' @importFrom SummarizedExperiment colData<-
#' @importFrom S4Vectors DataFrame
returnSamples <- function(sampleMetadata, dataType, counts = FALSE, rownames = "long") {
    if (inherits(sampleMetadata, "DataFrame")) {
        sampleMetadata <- as.data.frame(sampleMetadata)
    }
    if (!is.data.frame(sampleMetadata)) {
        stop("sampleMetadata must be a data.frame", call. = FALSE)
    }

    if (is.null(sampleMetadata[["study_name"]])) {
        stop("study_name must be present in sampleMetadata", call. = FALSE)
    }

    if (is.null(sampleMetadata[["sample_id"]])) {
        stop("sample_id must be present in sampleMetadata", call. = FALSE)
    }

    if (nrow(sampleMetadata) == 0L) {
        stop("sampleMetadata has no rows", call. = FALSE)
    }

    dataType <- .cmd_check_data_type(dataType)
    rownames <- match.arg(rownames, c("long", "short", "NCBI"))

    sampleMetadata <- as.data.frame(sampleMetadata, stringsAsFactors = FALSE)

    ## Run accessions are the key into the release; look them up from the
    ## package metadata when the caller has dropped the column.
    accession <- sampleMetadata[["ncbi_accession"]]
    if (is.null(accession)) {
        all_meta <- curatedMetagenomicData::all_meta
        idx <- match(
            str_c(sampleMetadata[["study_name"]], sampleMetadata[["sample_id"]], sep = "\r"),
            str_c(all_meta[["study_name"]], all_meta[["sample_id"]], sep = "\r")
        )
        accession <- all_meta[["ncbi_accession"]][idx]
    }

    rel <- cmdRelease()
    in_release <- cmgdr::cmgd_studies(rel)[["study_name"]]

    studies <- unique(sampleMetadata[["study_name"]])
    missing_studies <- setdiff(studies, in_release)
    studies <- intersect(studies, in_release)

    if (length(studies) == 0L) {
        stop(
            "none of the studies in sampleMetadata are in release ",
            rel[["dataset"]], "/", rel[["release"]], ": ",
            str_c(missing_studies, collapse = ", "),
            call. = FALSE
        )
    }

    con <- NULL
    if (dataType %in% c("marker_abundance", "marker_presence")) {
        con <- .cmd_connect(rel)
        on.exit(.cmd_disconnect(con), add = TRUE)
    }

    sample_key <- rep(NA_character_, nrow(sampleMetadata))
    repeated <- rep(FALSE, nrow(sampleMetadata))
    objects <- vector("list", length(studies))
    names(objects) <- studies

    for (study in studies) {
        rows <- which(sampleMetadata[["study_name"]] == study)
        qc <- .cmd_qc(rel, study)
        key <- .cmd_match_samples(qc, accession[rows])
        ## One row per sample: keep the first of any repeats.
        again <- duplicated(key) & !is.na(key)
        repeated[rows[again]] <- TRUE
        key[again] <- NA_character_
        sample_key[rows] <- key
        rows <- rows[!is.na(key)]
        if (length(rows) == 0L) {
            next
        }
        keys <- sample_key[rows]
        qc_cols <- .cmd_qc_cols(qc)[keys, , drop = FALSE]
        colData <- cbind(
            sampleMetadata[rows, setdiff(names(sampleMetadata), names(qc_cols)), drop = FALSE],
            qc_cols
        )
        rownames(colData) <- keys
        objects[[study]] <- .cmd_study_object(
            rel, study, dataType,
            samples = keys,
            colData = colData,
            counts = counts,
            rownames = rownames,
            con = con
        )
    }

    objects <- objects[!vapply(objects, is.null, logical(1L))]

    if (any(repeated)) {
        message("keeping ", sum(repeated), " repeated sample(s) once")
    }

    dropped <- is.na(sample_key) & !repeated
    if (any(dropped)) {
        names <- paste(
            sampleMetadata[["study_name"]][dropped],
            sampleMetadata[["sample_id"]][dropped],
            sep = "."
        )
        message(
            "dropping ", sum(dropped), " sample(s) not in release ",
            rel[["dataset"]], "/", rel[["release"]], ":\n  ",
            paste(utils::head(names, 20L), collapse = ", "),
            if (sum(dropped) > 20L) ", ..." else "",
            "\n"
        )
    }

    if (length(objects) == 0L) {
        stop("no samples in sampleMetadata are in the release", call. = FALSE)
    }

    to_return <- mergeData(objects)

    ## Keep the caller's row order.
    keep <- sample_key[!is.na(sample_key)]
    to_return[, keep]
}
