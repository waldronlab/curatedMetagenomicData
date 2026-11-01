#' Manually Curated Sample Metadata
#'
#' Manually curated sample metadata for every curated sample in
#' curatedMetagenomicData, one row per sample. It is built from
#' `curatedMetagenomicDataCuration::makeCombinedMetadata(TRUE)` by
#' `data-raw/sampleMetadata.R`, so the package does not depend on the
#' curation repository at run time.
#'
#' Two columns identify a sample: `study_name`, which is used with
#' [curatedMetagenomicData()] to query and return resources, and `sample_id`,
#' which with `study_name` identifies a curated sample for [returnSamples()].
#' The `ncbi_accession` column (`;`-separated run accessions) is what joins a
#' curated sample to the release in use (see [cmdRelease]); not every curated
#' sample is in the release yet.
#'
#' @section Harmonized columns:
#'
#' The columns defined in the cMD 4 data dictionary (the harmonized schema:
#' `age_years`, `sex`, `body_site`, `target_condition`, `control`, ...) are
#' named in `attr(sampleMetadata, "harmonized")`, and are the columns to
#' filter on for portable, cross-study cohorts. The remaining columns are
#' the ontology term ids for the harmonized fields
#' (`body_site_ontology_term_id`, ...), fields kept from version 3 that are
#' not in the dictionary (`alcohol`, `body_subsite`, ...), and study-specific
#' fields still under harmonization, most of which are `NA` outside one or
#' two studies and may be renamed or dropped as harmonization proceeds. After
#' filtering to a cohort, `dplyr::select(where(~ !all(is.na(.x))))` drops the
#' columns that are empty for it.
#'
#' Compared to version 3, the column names follow the cMD 4 data dictionary:
#' for example `NCBI_accession` is `ncbi_accession`, `age` is joined by
#' `age_years` and `age_unit`, `disease` by `target_condition` and `control`,
#' and `body_site` uses UBERON names (`feces`, not `stool`). `number_reads`
#' is no longer curated; it comes from the release's QC table in the
#' `colData` of returned objects. The complete map from the version 3
#' columns and values to version 4 is shipped as
#' `system.file("extdata", "cmd3_to_cmd4_columns.csv", package = "curatedMetagenomicData")`
#' (one row per version 3 column), `cmd3_to_cmd4_values.csv` (value maps for
#' recoded columns) and `cmd3_to_cmd4_conditions.csv` (`study_condition` and
#' `disease` to `target_condition`, `control` and `disease`), and rendered in
#' the article "Migrating from version 3".
#'
#' @format A `data.frame` with one row per curated sample and one column per
#' field, with a `harmonized` attribute naming the data dictionary columns.
#'
#' @seealso [curatedMetagenomicData], [returnSamples]
#'
#' @examples
#' attr(sampleMetadata, "harmonized")
#'
#' sampleMetadata |>
#'     dplyr::filter(study_name == "AsnicarF_2017") |>
#'     dplyr::select(where(~ !all(is.na(.x)))) |>
#'     head()
"sampleMetadata"
