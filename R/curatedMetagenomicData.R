#' Access Curated Metagenomic Data
#'
#' To access curated metagenomic data users will use `curatedMetagenomicData()`
#' after "shopping" the [sampleMetadata] `data.frame` for studies they are
#' interested in. The `dryrun` argument allows users to perfect a query prior
#' to returning resources. When `dryrun = TRUE`, matched resources will be
#' printed before they are returned invisibly as a character vector. When
#' `dryrun = FALSE`, a `list` of resources containing
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment-class]
#' and/or
#' [TreeSummarizedExperiment][TreeSummarizedExperiment::TreeSummarizedExperiment-class]
#' objects, each with corresponding sample metadata, is returned. Multiple
#' resources can be returned simultaneously. Finally, if a
#' `relative_abundance` resource is requested and `counts = TRUE`, relative
#' abundance proportions will be multiplied by read depth and rounded to the
#' nearest integer.
#'
#' Since version 4.0.0, resources are read from the public
#' curatedMetagenomicData releases at
#' <https://cmgd-public.cancerdatasci.org> rather than from ExperimentHub;
#' see [cmdRelease] for the release in use and how to change it. A resource
#' is one study and one data type in that release, titled
#' `<release>.<study_name>.<dataType>`. Every study published in the release
#' is a resource, whether or not it has curated metadata yet; the
#' `colData` of each object holds the matching [sampleMetadata] columns
#' (`NA` for samples without curated metadata) followed by the release's
#' per-sample QC columns (`sample_key`, `run_ids`, `number_reads`, ...).
#' Columns are named by the release's `sample_key`.
#'
#' @section Data types:
#'
#' * `relative_abundance`: MetaPhlAn 4 species relative abundance, in
#'   percent, from the main pass on all reads. A
#'   `TreeSummarizedExperiment` with `rowData` columns for each rank and
#'   `ncbi_taxid`. No row tree is attached in this version.
#' * `marker_abundance`, `marker_presence`: MetaPhlAn marker abundance and
#'   presence (1 where present). These are read from the release's catalog
#'   rather than per-study files and take longer, roughly 15 seconds per
#'   study.
#' * `bracken`: Kraken2/Bracken species profile, as the fraction of total
#'   reads (0 to 1), with `ncbi_taxid` in `rowData`.
#' * `resistome`: KMA depth per CARD reference template.
#'
#' The HUMAnN data types of version 3 (`gene_families`, `pathway_abundance`,
#' `pathway_coverage`) are not available until the HUMAnN datasets are
#' published.
#'
#' @section Taxonomic names:
#'
#' The three `rownames` options for `relative_abundance` are different
#' vocabularies. `"long"` is the MetaPhlAn clade string exactly as reported
#' by the MetaPhlAn database the release was built with (see
#' `cmgdr::cmgd_provenance(cmdRelease())`). `"short"` is the species part of
#' that string. `"NCBI"` is the NCBI Taxonomy ID MetaPhlAn assigns to the
#' species; MetaPhlAn 4 species-level genome bins without a named species
#' have none and are dropped with a warning, and clades sharing one
#' identifier are summed with a message. Every option carries the same
#' `rowData`: one column per rank (`superkingdom` to `species`, as names) and
#' the integer `ncbi_taxid`, which is the column to join on when matching
#' profiles generated elsewhere.
#'
#' @param pattern regular expression pattern to look for in the titles of
#' resources available in curatedMetagenomicData; `""` will return all resources
#'
#' @param dryrun if `TRUE` (the default), a character vector of resource names
#' is returned invisibly; if `FALSE`, a `list` of resources is returned
#'
#' @param counts if `FALSE` (the default), relative abundance proportions are
#' returned; if `TRUE`, relative abundance proportions are multiplied by read
#' depth and rounded to the nearest integer prior to being returned
#'
#' @param rownames the type of `rownames` to use for `relative_abundance`
#' resources, one of: `"long"` (the default, the full MetaPhlAn clade string),
#' `"short"` (species name), or `"NCBI"` (NCBI Taxonomy ID); see the
#' Taxonomic names section
#'
#' @return if `dryrun = TRUE`, a character vector of resource names is returned
#' invisibly; if `dryrun = FALSE`, a `list` of resources is returned
#' @export
#'
#' @seealso [mergeData], [returnSamples], [sampleMetadata], [cmdRelease]
#'
#' @examples
#' curatedMetagenomicData("AsnicarF_20.+")
#'
#' curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE)
#'
#' curatedMetagenomicData("AsnicarF_2017.relative_abundance", dryrun = FALSE, counts = TRUE)
#'
#' @importFrom stringr str_subset str_c
curatedMetagenomicData <- function(pattern, dryrun = TRUE, counts = FALSE, rownames = "long") {
    if (missing(pattern)) {
        stop("the pattern argument is missing", call. = FALSE)
    }
    rownames <- match.arg(rownames, c("long", "short", "NCBI"))

    rel <- cmdRelease()

    resources <-
        str_subset(.cmd_resource_titles(rel), pattern)

    if (length(resources) == 0) {
        stop("no resources available in curatedMetagenomicData", call. = FALSE)
    }

    if (dryrun) {
        str_c(resources, collapse = "\n") |>
            message()

        return(invisible(resources))
    }

    parts <- .cmd_split_titles(resources)

    con <- NULL
    if (any(parts[["data_type"]] %in% c("marker_abundance", "marker_presence"))) {
        con <- .cmd_connect(rel)
        on.exit(.cmd_disconnect(con), add = TRUE)
    }

    resource_list <- vector("list", length(resources))
    names(resource_list) <- resources

    meta <- curatedMetagenomicData::sampleMetadata

    for (i in seq_along(resources)) {
        study <- parts[[i, "study_name"]]
        qc <- .cmd_qc(rel, study)
        colData <- .cmd_study_col_data(qc, study, meta)
        resource_list[[i]] <- .cmd_study_object(
            rel, study, parts[[i, "data_type"]],
            samples = qc[["sample_key"]],
            colData = colData,
            counts = counts,
            rownames = rownames,
            con = con,
            label = resources[[i]]
        )
    }

    resource_list
}
