## cMD4 data access layer (internal) -----------------------------------------
##
## Everything here is private. The user-facing API is
## curatedMetagenomicData(), returnSamples() and mergeData(), plus the
## sampleMetadata data object; cmdRelease() names the
## release being read.
##
## A release publishes, per study, ready-made files (metaphlan_species.tsv.gz,
## metaphlan.parquet, bracken.parquet, resistome.parquet, qc.tsv) and, for
## the whole release, Parquet tables behind a DuckLake catalog. The per-study
## files cover relative_abundance, bracken and resistome; marker_abundance
## and marker_presence have no per-study file and are read from the catalog
## with a study filter (around 15 seconds per study). Samples are identified
## by the release's `sample_key`; curated metadata is joined to them by run
## accession (see .cmd_match_samples()).

## ---- data types -----------------------------------------------------------

.cmd_data_types <- c(
    "relative_abundance",
    "marker_abundance",
    "marker_presence",
    "bracken",
    "resistome"
)

.cmd_check_data_type <- function(dataType) {
    if (!is.character(dataType) || length(dataType) != 1L) {
        stop("dataType must be a single character string", call. = FALSE)
    }
    if (dataType %in% c("gene_families", "pathway_abundance", "pathway_coverage")) {
        stop(
            "dataType '", dataType, "' is not in the ",
            "curatedMetagenomicData 4 release yet: the HUMAnN datasets are ",
            "not published. Available: ",
            paste(.cmd_data_types, collapse = ", "),
            call. = FALSE
        )
    }
    if (!dataType %in% .cmd_data_types) {
        stop(
            "unknown dataType '", dataType, "'. Available: ",
            paste(.cmd_data_types, collapse = ", "),
            call. = FALSE
        )
    }
    dataType
}

## ---- resource titles ------------------------------------------------------

## Resource titles keep the cMD3 dotted form `<date>.<study_name>.<dataType>`
## where the date is the release id. Studies come from the release.
.cmd_resource_titles <- function(rel = cmdRelease()) {
    studies <- sort(cmgdr::cmgd_studies(rel)[["study_name"]])
    as.vector(outer(
        studies, .cmd_data_types,
        FUN = function(s, d) paste(rel[["release"]], s, d, sep = ".")
    ))
}

.cmd_split_titles <- function(titles) {
    pieces <- strsplit(titles, ".", fixed = TRUE)
    bad <- lengths(pieces) != 3L
    if (any(bad)) {
        stop("malformed resource title(s): ",
             paste(titles[bad], collapse = ", "), call. = FALSE)
    }
    data.frame(
        release = vapply(pieces, `[[`, character(1L), 1L),
        study_name = vapply(pieces, `[[`, character(1L), 2L),
        data_type = vapply(pieces, `[[`, character(1L), 3L),
        stringsAsFactors = FALSE
    )
}

## ---- per-study reads ------------------------------------------------------

.cmd_read_study <- function(rel, study, what) {
    cmgdr::cmgd_read_study(rel, study, what, cache = .cmd_cache())
}

## qc.tsv: one row per sample_key, with run_ids and read counts. Row names
## are sample_key.
.cmd_qc <- function(rel, study) {
    qc <- .cmd_read_study(rel, study, "qc")
    qc <- qc[order(qc[["sample_key"]]), , drop = FALSE]
    rownames(qc) <- qc[["sample_key"]]
    qc
}

## Pivot a long table to a dense feature x sample matrix over `samples`,
## zero where a feature has no row for a sample.
.cmd_pivot <- function(long, feature, sample, value, samples) {
    keep <- long[[sample]] %in% samples
    long <- long[keep, , drop = FALSE]
    features <- sort(unique(long[[feature]]))
    mat <- matrix(
        0, length(features), length(samples),
        dimnames = list(features, samples)
    )
    if (nrow(long)) {
        idx <- cbind(
            match(long[[feature]], features),
            match(long[[sample]], samples)
        )
        mat[idx] <- as.numeric(long[[value]])
    }
    mat
}

## Species x samples relative abundance (percent) from the per-study
## metaphlan_species.tsv.gz, over every sample in qc.
.cmd_species_matrix <- function(rel, study, samples) {
    species <- .cmd_read_study(rel, study, "metaphlan_species")
    clade <- species[["clade_name"]]
    mat <- matrix(
        0, length(clade), length(samples),
        dimnames = list(clade, samples)
    )
    measured <- intersect(names(species)[-1L], samples)
    mat[, measured] <- as.matrix(species[measured])
    mat
}

## clade_name -> ncbi_taxid for the species rows of the main MetaPhlAn pass.
.cmd_species_taxid <- function(rel, study) {
    mp <- .cmd_read_study(rel, study, "metaphlan")
    ## which() because rank is NA on a few rows, and NA in a logical index
    ## would insert all-NA rows
    mp <- mp[
        which(
            mp[["rank"]] == "species" &
                mp[["data_type"]] == "full_data" &
                is.na(mp[["humann_bundle"]])
        ),
        c("clade_name", "ncbi_taxid"),
        drop = FALSE
    ]
    mp <- mp[!duplicated(mp[["clade_name"]]), , drop = FALSE]
    taxid <- as.integer(mp[["ncbi_taxid"]])
    names(taxid) <- mp[["clade_name"]]
    taxid
}

## Markers come from the release tables through the DuckLake catalog.
.cmd_marker_matrix <- function(con, dataType, study, samples) {
    if (dataType == "marker_abundance") {
        long <- DBI::dbGetQuery(
            con,
            paste(
                "SELECT sample_key, marker_name, value",
                "FROM marker_abundance",
                "WHERE study_name = ? AND data_type = 'full_data'"
            ),
            params = list(study)
        )
    } else {
        long <- DBI::dbGetQuery(
            con,
            paste(
                "SELECT sample_key, marker_name, 1 AS value",
                "FROM marker_presence",
                "WHERE study_name = ? AND data_type = 'full_data'"
            ),
            params = list(study)
        )
    }
    .cmd_pivot(long, "marker_name", "sample_key", "value", samples)
}

.cmd_bracken <- function(rel, study, samples) {
    long <- .cmd_read_study(rel, study, "bracken")
    ## Bracken reports every species in its database, almost all at zero.
    long <- long[
        which(
            long[["data_type"]] == "full_data" &
                long[["rank"]] == "species" &
                long[["fraction_total_reads"]] > 0
        ), ,
        drop = FALSE
    ]
    mat <- .cmd_pivot(
        long, "clade_name", "sample_key", "fraction_total_reads", samples
    )
    taxid <- long[!duplicated(long[["clade_name"]]), c("clade_name", "ncbi_taxid")]
    rowData <- S4Vectors::DataFrame(
        rank = rep("species", nrow(mat)),
        ncbi_taxid = as.integer(taxid[["ncbi_taxid"]][match(rownames(mat), taxid[["clade_name"]])]),
        row.names = rownames(mat)
    )
    list(assay = mat, rowData = rowData)
}

.cmd_resistome <- function(rel, study, samples) {
    long <- .cmd_read_study(rel, study, "resistome")
    long <- long[which(long[["data_type"]] == "full_data"), , drop = FALSE]
    mat <- .cmd_pivot(long, "gene", "sample_key", "depth", samples)
    list(assay = mat, rowData = NULL)
}

## A DuckDB connection to the release catalog, opened only when a marker
## data type is requested.
.cmd_connect <- function(rel) {
    cmgdr::cmgd_connect(rel, cache = .cmd_cache())
}

.cmd_disconnect <- function(con) {
    if (!is.null(con)) {
        suppressWarnings(
            try(DBI::dbDisconnect(con, shutdown = TRUE), silent = TRUE)
        )
    }
    invisible(NULL)
}

## ---- sample identity ------------------------------------------------------

## Match curated metadata rows to a study's sample_keys by run accession.
## `qc` is the study's qc table (run_ids `;`-joined); `accessions` is the
## curated `ncbi_accession` column (`;`-joined) for the rows to match.
## Returns one sample_key per row, NA when a row's runs match no sample or
## more than one.
.cmd_match_samples <- function(qc, accessions) {
    q_runs <- strsplit(qc[["run_ids"]], ";", fixed = TRUE)
    ## one row per (run, sample_key): a run can in principle belong to more
    ## than one sample, and a curated row matching two keys is ambiguous
    runs <- data.frame(
        run = trimws(unlist(q_runs)),
        key = rep(qc[["sample_key"]], lengths(q_runs)),
        stringsAsFactors = FALSE
    )
    accessions[is.na(accessions)] <- ""
    m_runs <- strsplit(accessions, ";", fixed = TRUE)
    vapply(m_runs, function(r) {
        keys <- unique(runs[["key"]][runs[["run"]] %in% trimws(r)])
        if (length(keys) == 1L) keys else NA_character_
    }, character(1L))
}

## qc columns kept in colData, after the curated columns. `number_reads`
## (reads after host decontamination) is what `counts = TRUE` multiplies by.
.cmd_qc_cols <- function(qc) {
    drop <- c("sample_id", "readset_id", "study_name", "workflow_id", "version")
    out <- qc[, setdiff(names(qc), drop), drop = FALSE]
    out[["number_reads"]] <- as.numeric(qc[["reads_decontaminated"]])
    out
}

## colData for every sample of a study: curated columns from `meta`
## (sampleMetadata by default) where a sample matches, NA otherwise, then
## the qc columns. Rows and row names are the study's sample_keys.
.cmd_study_col_data <- function(qc, study, meta) {
    curated <- meta[meta[["study_name"]] == study, , drop = FALSE]
    key <- .cmd_match_samples(qc, curated[["ncbi_accession"]])
    curated <- curated[!is.na(key), , drop = FALSE]
    key <- key[!is.na(key)]
    if (anyDuplicated(key)) {
        dup <- unique(key[duplicated(key)])
        warning(
            length(dup), " sample(s) of ", study,
            " match more than one curated metadata row; keeping the first: ",
            paste(utils::head(dup, 5L), collapse = ", "),
            if (length(dup) > 5L) ", ..." else "",
            call. = FALSE
        )
        curated <- curated[!duplicated(key), , drop = FALSE]
        key <- key[!duplicated(key)]
    }
    curated <- curated[match(qc[["sample_key"]], key), , drop = FALSE]
    rownames(curated) <- qc[["sample_key"]]
    curated[["study_name"]] <- study
    curated <- curated[, vapply(curated, function(x) !all(is.na(x)), logical(1L)), drop = FALSE]
    out <- cbind(curated, .cmd_qc_cols(qc))
    rownames(out) <- qc[["sample_key"]]
    out
}

## ---- assembling objects ---------------------------------------------------

.cmd_ranks <- c(
    "superkingdom", "phylum", "class", "order", "family", "genus", "species"
)

## Parse MetaPhlAn clade strings into one column per rank, with the rank
## prefix removed.
.cmd_parse_clades <- function(clade) {
    parts <- strsplit(clade, "|", fixed = TRUE)
    out <- lapply(seq_along(.cmd_ranks), function(i) {
        vapply(parts, function(p) {
            if (length(p) >= i) sub("^[a-z]__", "", p[[i]]) else NA_character_
        }, character(1L))
    })
    names(out) <- .cmd_ranks
    S4Vectors::DataFrame(out, row.names = clade)
}

## Build the TreeSummarizedExperiment for relative_abundance. `mat` is
## species (long clade names) x sample_key, percent.
.cmd_relative_abundance_tse <- function(mat, colData, taxid, counts, rownames,
                                        label = NULL) {
    rowData <- .cmd_parse_clades(rownames(mat))
    rowData[["ncbi_taxid"]] <- unname(taxid[rownames(mat)])

    if (counts) {
        nreads <- colData[["number_reads"]]
        if (anyNA(nreads)) {
            warning(
                "number_reads is missing for ", sum(is.na(nreads)),
                " sample(s); their count values are NA",
                call. = FALSE
            )
        }
        mat <- round(t(t(mat) * nreads / 100))
        storage.mode(mat) <- "integer"
    }

    label <- if (is.null(label)) "" else paste0(" of `", label, "`")

    if (rownames == "NCBI") {
        no_id <- is.na(rowData[["ncbi_taxid"]])
        if (any(no_id)) {
            warning(
                "dropping ", sum(no_id), " of ", nrow(mat), " taxa", label,
                " with no NCBI Taxonomy ID (MetaPhlAn species-level genome ",
                "bins without a named species). Use rownames = \"long\" or ",
                "\"short\" to keep every taxon.",
                call. = FALSE
            )
            mat <- mat[!no_id, , drop = FALSE]
            rowData <- rowData[!no_id, , drop = FALSE]
        }
        id <- as.character(rowData[["ncbi_taxid"]])
        if (anyDuplicated(id)) {
            merged <- unique(id[duplicated(id)])
            message(
                "merging ", sum(id %in% merged), " rows", label,
                " into ", length(merged),
                " NCBI Taxonomy IDs, summing their values"
            )
            mat <- rowsum(mat, id, reorder = FALSE)
            rowData <- rowData[!duplicated(id), , drop = FALSE]
            rownames(rowData) <- rownames(mat)
        } else {
            rownames(mat) <- id
            rownames(rowData) <- id
        }
    } else if (rownames == "short") {
        short <- rowData[["species"]]
        rownames(mat) <- short
        rownames(rowData) <- short
    }

    assays <- S4Vectors::SimpleList(mat)
    names(assays) <- "relative_abundance"
    TreeSummarizedExperiment::TreeSummarizedExperiment(
        assays = assays,
        rowData = rowData,
        colData = S4Vectors::DataFrame(colData, check.names = FALSE)
    )
}

.cmd_se <- function(mat, rowData, colData, dataType) {
    assays <- S4Vectors::SimpleList(mat)
    names(assays) <- dataType
    if (is.null(rowData)) {
        SummarizedExperiment::SummarizedExperiment(
            assays = assays,
            colData = S4Vectors::DataFrame(colData, check.names = FALSE)
        )
    } else {
        SummarizedExperiment::SummarizedExperiment(
            assays = assays,
            rowData = rowData,
            colData = S4Vectors::DataFrame(colData, check.names = FALSE)
        )
    }
}

## One study, one data type, for the given sample_keys (a subset of the
## study's samples), with `colData` rows in the same order. `con` is an
## open catalog connection, needed for the marker data types only.
.cmd_study_object <- function(rel, study, dataType, samples, colData,
                              counts = FALSE, rownames = "long", con = NULL,
                              label = NULL) {
    if (dataType == "relative_abundance") {
        mat <- .cmd_species_matrix(rel, study, samples)
        taxid <- .cmd_species_taxid(rel, study)
        return(.cmd_relative_abundance_tse(
            mat, colData, taxid, counts, rownames, label
        ))
    }
    if (dataType %in% c("marker_abundance", "marker_presence")) {
        mat <- .cmd_marker_matrix(con, dataType, study, samples)
        return(.cmd_se(mat, NULL, colData, dataType))
    }
    if (dataType == "bracken") {
        x <- .cmd_bracken(rel, study, samples)
    } else {
        x <- .cmd_resistome(rel, study, samples)
    }
    .cmd_se(x[["assay"]], x[["rowData"]], colData, dataType)
}
