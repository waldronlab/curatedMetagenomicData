#' Combined Sample Metadata Including Under-Harmonization Columns (cMD4)
#'
#' The `all_meta` `data.frame` is the per-sample metadata table for
#' curatedMetagenomicData 4.0 that combines the harmonized columns from
#' [harmonized_meta] with study-specific columns that have not yet been
#' folded into the cMD harmonization schema. Use this object when
#' inspecting studies that are still under harmonization or when you
#' need raw fields that are not part of the released data dictionary.
#'
#' For day-to-day cohort assembly prefer [harmonized_meta], whose
#' columns are guaranteed to follow the schema and thus to be portable
#' across studies.
#'
#' Key columns used by the cMD4 data access layer are `study_name` and
#' `sample_id`; `sample_id` is the join key against the cMD4 DuckDB views.
#'
#' @seealso [harmonized_meta], [returnSamples()],
#'   [curatedMetagenomicData()]
#' @format A `data.frame` with one row per sample and one column per
#'   field. Built from `inst/extdata/all_meta.csv`, the staged copy of
#'   `curatedMetagenomicDataCuration::makeCombinedMetadata(TRUE)`.
"all_meta"
