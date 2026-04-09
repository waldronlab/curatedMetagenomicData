#' Harmonized Sample Metadata (cMD4)
#'
#' The `harmonized_meta` `data.frame` is the schema-aligned harmonized
#' sample metadata release for curatedMetagenomicData 4.0. It contains
#' one row per sample, restricted to the columns defined in the cMD
#' harmonization data dictionary, with curated clinical, lifestyle, and
#' sequencing fields and ontology term identifiers for values drawn from
#' controlled vocabularies. Use [all_meta] when you also need study-
#' specific columns that have not yet been folded into the schema.
#'
#' Key columns used by the cMD4 data access layer are `study_name` and
#' `sample_id`; `sample_id` is the join key against the cMD4 DuckDB views
#' (it corresponds to the `sample_name` column in the ETL `sample_id_map`).
#'
#' Users filter this table to the samples of interest and then pass the
#' subset to [returnSamples()] to obtain a `SummarizedExperiment` for the
#' desired data type, or use [curatedMetagenomicData()] to retrieve
#' study-level resources by regular-expression pattern.
#'
#' @seealso [all_meta], [returnSamples()], [curatedMetagenomicData()]
#' @format A `data.frame` with one row per sample and one column per
#'   harmonized field. Built from
#'   `inst/extdata/harmonized_meta.csv`, the staged copy of
#'   `curatedMetagenomicDataCuration::makeCombinedMetadata()`.
"harmonized_meta"
