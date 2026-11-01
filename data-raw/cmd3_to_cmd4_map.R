## Build the version 3 to version 4 metadata map shipped in inst/extdata.
##
## The cMD 3 table is the sampleMetadata object of the last version 3
## release (branch RELEASE_3_23 of this repository); the cMD 4 table is this
## package's sampleMetadata. The curation repository's
## inst/extdata/sampleMetadata.csv is the same cMD 3 table with a few column
## names as they were before the final release (hsCRP, LDL, smoke, ...), so
## the package copy is used. Joining the two on study_name + sample_id gives,
## for every cMD 3 column, where its values went. The column-level decisions
## below were made by hand from that comparison; the script checks each one
## against the data (coverage of the cMD 3 values by the cMD 4 column) and
## derives the value-level maps.
##
## Outputs:
##   inst/extdata/cmd3_to_cmd4_columns.csv     one row per cMD 3 column
##   inst/extdata/cmd3_to_cmd4_values.csv      value maps for recoded columns
##   inst/extdata/cmd3_to_cmd4_conditions.csv  study_condition + disease ->
##                                             target_condition + control + disease

suppressMessages(library(dplyr))

cmd3_file <- tempfile(fileext = ".rda")
system2("git", c("show", "origin/RELEASE_3_23:data/sampleMetadata.rda"), stdout = cmd3_file)
load(cmd3_file)
cmd3 <- sampleMetadata
load("data/sampleMetadata.rda")
cmd4 <- sampleMetadata

key3 <- paste(cmd3$study_name, cmd3$sample_id)
key4 <- paste(cmd4$study_name, cmd4$sample_id)
stopifnot(sum(key3 %in% key4) > 0.99 * nrow(cmd3))
j4 <- cmd4[match(key3, key4), ]

norm <- function(x) trimws(as.character(x))

## ---- column decisions -----------------------------------------------------
##
## relation:
##   same         same name, same values
##   renamed      new name, same values
##   recoded      same name, values changed (see cmd3_to_cmd4_values.csv)
##   renamed+recoded
##   restructured several columns replace it (notes say how)
##   biomarker    packed into biomarker_name / biomarker_unit / biomarker_value
##   uncurated    packed into uncurated_metadata as "<name>:<value>"
##   dropped      not carried into version 4
map <- tribble(
    ~cmd3, ~cmd4, ~relation, ~notes,
    "study_name", "study_name", "same", "",
    "sample_id", "sample_id", "same", "",
    "subject_id", "subject_id", "same", "",
    "body_site", "body_site", "recoded", "UBERON names: stool is feces, oralcavity is oral cavity, skin is skin epidermis, nasalcavity is nasal cavity",
    "antibiotics_current_use", "antibiotics_current_use", "recoded", "yes/no become Yes/No; Not applicable where not relevant",
    "study_condition", "target_condition;control;disease", "restructured", "target_condition names the condition(s) the study targets, control is Case / Study Control / Not Used, disease lists the participant's conditions; see cmd3_to_cmd4_conditions.csv",
    "disease", "target_condition;control;disease", "restructured", "see study_condition",
    "age", "age;age_unit;age_years;age_min;age_max", "restructured", "age is the value in age_unit (Year, Month, Day); age_years is the age in years; age_min/age_max bound an age given as a range",
    "infant_age", "age;age_unit;age_years", "restructured", "infant ages in days become age with age_unit Day; cMD 3 age for the same sample was the floor in years",
    "age_category", "age_group", "renamed+recoded", "age_group is re-derived from age_years (Newborn, Infant, Child, Adolescent, Adult, Elderly), so it does not map one to one",
    "gender", "sex", "renamed+recoded", "",
    "country", "country", "recoded", "ISO 3166 alpha-3 codes become country names",
    "location", "location", "same", "",
    "non_westernized", "westernized", "renamed+recoded", "sense inverted: non_westernized yes is westernized No",
    "sequencing_platform", "sequencing_platform", "same", "",
    "DNA_extraction_kit", "dna_extraction_kit", "renamed", "",
    "PMID", "pmid", "renamed", "",
    "number_reads", "", "dropped", "read counts now come from the release QC table (number_reads in the colData of returned objects)",
    "number_bases", "", "dropped", "see number_reads (bases_decontaminated in the QC columns)",
    "minimum_read_length", "", "dropped", "",
    "median_read_length", "", "dropped", "",
    "NCBI_accession", "ncbi_accession", "renamed", "",
    "pregnant", "obgyn_pregnancy", "renamed+recoded", "",
    "lactating", "obgyn_lactating", "renamed+recoded", "",
    "curator", "curator", "recoded", "the separator between names is , in some studies and ; in others",
    "BMI", "bmi", "renamed", "",
    "family", "family", "same", "",
    "treatment", "treatment", "recoded", "free text becomes NCIT names (one per treatment, comma separated); cMD 3 'no' becomes None or NA",
    "days_from_first_collection", "days_from_first_collection", "same", "a few studies re-curated the values",
    "family_role", "family_role", "same", "",
    "born_method", "neonatal_delivery_procedure", "renamed+recoded", "",
    "c_section_type", "neonatal_delivery_procedure", "renamed+recoded", "Elective_CS / Emergency_CS become Elective / Emergency Cesarean Delivery",
    "feeding_practice", "neonatal_feeding_method", "renamed+recoded", "",
    "premature", "neonatal_preterm_birth", "renamed+recoded", "",
    "birth_weight", "neonatal_birth_weight", "renamed", "",
    "gestational_age", "neonatal_gestational_age", "renamed", "",
    "diet", "dietary_restriction", "renamed", "",
    "subcohort", "subcohort", "same", "",
    "smoker", "smoker", "recoded", "yes/no become SNOMED finding names, possibly several (Smoker (finding); Non-smoker (finding); Ex-smoker (finding); Never smoked tobacco (finding))",
    "ever_smoker", "smoker", "renamed+recoded", "folded into smoker",
    "lifestyle", "lifestyle", "same", "",
    "population", "ancestry;ancestry_details", "renamed+recoded", "ancestry is a broad category; the cMD 3 value is kept in ancestry_details where it was a named population",
    "menopausal_status", "obgyn_menopause", "renamed+recoded", "",
    "birth_control_pil", "obgyn_birth_control", "renamed+recoded", "",
    "body_subsite", "body_site_details", "renamed+recoded", "UBERON names; stool becomes Not applicable",
    "disease_subtype", "disease_details", "renamed+recoded", "",
    "disease_stage", "tumor_staging_ajcc", "renamed", "",
    "ajcc", "tumor_staging_ajcc", "renamed+recoded", "upper case",
    "tnm", "tumor_staging_tnm", "renamed+recoded", "upper case",
    "RECIST", "disease_response_recist", "renamed+recoded", "",
    "ORR", "disease_response_orr", "renamed+recoded", "",
    "PFS12", "disease_response_pfs;disease_response_pfs_month", "restructured", "",
    "anti_PD_1", "treatment", "restructured", "folded into treatment",
    "history_of_therapy", "previous_therapy", "renamed+recoded", "",
    "FMT_role", "fmt_role", "renamed+recoded", "",
    "fmt_id", "fmt_id", "same", "",
    "HLA", "hla", "renamed+recoded", "",
    "bristol_score", "feces_phenotype;feces_phenotype_value", "restructured", "feces_phenotype says which score, feces_phenotype_value holds it",
    "calprotectin", "feces_phenotype;feces_phenotype_value", "restructured", "see bristol_score",
    "zigosity", "zigosity", "same", "",
    "uncurated_metadata", "uncurated_metadata", "recoded", "now a ;-separated list of name:value pairs",
    "visit_number", "", "dropped", "",
    "alcohol", "", "dropped", "",
    "alcohol_numeric", "", "dropped", "",
    "brinkman_index", "", "dropped", "",
    "mgs_richness", "", "dropped", "derived value, not metadata",
    "hitchip_probe_class", "", "dropped", "",
    "ferm_milk_prod_consumer", "", "dropped", "",
    "dental_sample_type", "", "dropped", "",
    "history_of_periodontitis", "", "dropped", "",
    "disease_location", "", "dropped", "",
    "change_in_tumor_size", "", "dropped", "",
    "performance_status", "ecog_performance_status", "renamed", "",
    "toxicity_above_zero", "", "dropped", "",
    "remission", "", "dropped", "",
    "days_after_onset", "", "dropped", "",
    "flg_genotype", "", "dropped", "",
    "antibiotics_family", "", "dropped", "",
    "insulin_cat", "", "dropped", "",
    "stool_texture", "", "dropped", "",
    "mumps", "", "dropped", "",
    "birth_order", "", "dropped", "",
    "age_twins_started_to_live_apart", "", "dropped", "",
    "hla_drb12", "", "dropped", "",
    "hla_dqa12", "", "dropped", "",
    "hla_dqa11", "", "dropped", "",
    "hla_drb11", "", "dropped", "",
    "autoantibody_positive", "", "dropped", "",
    "glutamate_decarboxylase_2_antibody", "", "dropped", "",
    "stec_count", "", "dropped", "",
    "shigatoxin_2_elisa", "", "dropped", ""
)

## Columns packed into uncurated_metadata as "<cmd3 name>:<value>" are found
## from the data: the cMD 3 name appears as a key there for those samples.
um <- norm(j4[["uncurated_metadata"]])
um_keys <- function(a) {
    ok <- !is.na(cmd3[[a]]) & !is.na(um)
    if (!sum(ok)) return(0)
    mean(grepl(paste0("(^|;|>)", a, ":"), um[ok]))
}

## Columns packed into biomarker_*: biomarker_name, biomarker_unit and
## biomarker_value are aligned ;-separated lists. A cMD 3 column is a
## biomarker if, for (nearly) every sample with a value, that value sits at
## some position of biomarker_value, and the name at that position is the
## same across samples.
bio_names <- strsplit(norm(j4[["biomarker_name"]]), ";", fixed = TRUE)
bio_values <- lapply(strsplit(norm(j4[["biomarker_value"]]), ";", fixed = TRUE),
                     function(v) suppressWarnings(as.numeric(v)))
biomarker_token <- function(a) {
    x <- suppressWarnings(as.numeric(cmd3[[a]]))
    ok <- which(!is.na(x) & !is.na(j4[["biomarker_name"]]))
    if (length(ok) < 0.9 * sum(!is.na(cmd3[[a]]))) return(NA_character_)
    hits <- unlist(lapply(ok, function(i) {
        n <- bio_names[[i]]; v <- bio_values[[i]]
        if (length(n) != length(v)) return(NULL)
        n[!is.na(v) & abs(v - x[i]) < 1e-6]
    }))
    if (!length(hits)) return(NA_character_)
    ## The same biomarker is spelled differently across studies
    ## ("Cholesterol" and "Cholesterol Measurement"), so take the names that
    ## together cover the samples.
    tab <- sort(table(hits), decreasing = TRUE)
    keep <- which(cumsum(tab) <= 0.9 * length(ok)) + 1L
    keep <- unique(c(1L, keep[keep <= length(tab)]))
    if (sum(tab[keep]) < 0.9 * length(ok)) return(NA_character_)
    paste(names(tab)[keep], collapse = " / ")
}

## Every cMD 3 column not decided above is either a biomarker, uncurated, or
## dropped, decided from the data.
for (a in setdiff(names(cmd3), map$cmd3)) {
    token <- biomarker_token(a)
    if (!is.na(token)) {
        map <- add_row(map, cmd3 = a, cmd4 = "biomarker_name;biomarker_unit;biomarker_value",
                       relation = "biomarker", notes = paste0("biomarker_name is '", token, "'"))
    } else if (um_keys(a) >= 0.9) {
        map <- add_row(map, cmd3 = a, cmd4 = "uncurated_metadata",
                       relation = "uncurated", notes = paste0("as '", a, ":<value>'"))
    } else {
        map <- add_row(map, cmd3 = a, cmd4 = "", relation = "dropped", notes = "")
    }
}
## Check the hand decisions the same way, so a dropped column that is in
## fact packed is caught.
for (i in which(map$relation == "dropped")) {
    a <- map$cmd3[i]
    token <- biomarker_token(a)
    if (!is.na(token)) {
        map$cmd4[i] <- "biomarker_name;biomarker_unit;biomarker_value"
        map$relation[i] <- "biomarker"
        map$notes[i] <- paste0("biomarker_name is '", token, "'")
    } else if (um_keys(a) >= 0.9) {
        map$cmd4[i] <- "uncurated_metadata"
        map$relation[i] <- "uncurated"
        map$notes[i] <- paste0("as '", a, ":<value>'")
    }
}
stopifnot(setequal(map$cmd3, names(cmd3)))
map <- map[match(names(cmd3), map$cmd3), ]

## ---- coverage check -------------------------------------------------------
## Of the samples with a cMD 3 value, how many have a value in the first
## cMD 4 column named? Low coverage on a "same" or "renamed" row is a wrong
## decision.
map$n_cmd3 <- vapply(map$cmd3, function(a) sum(!is.na(cmd3[[a]])), integer(1L))
map$coverage <- vapply(seq_len(nrow(map)), function(i) {
    a <- map$cmd3[i]
    b <- strsplit(map$cmd4[i], ";", fixed = TRUE)[[1]][1]
    if (is.na(b) || !nzchar(b) || !b %in% names(j4)) return(NA_real_)
    ok <- !is.na(cmd3[[a]])
    round(mean(!is.na(j4[[b]][ok])), 3)
}, numeric(1L))
map$identical <- vapply(seq_len(nrow(map)), function(i) {
    if (!map$relation[i] %in% c("same", "renamed")) return(NA_real_)
    a <- map$cmd3[i]; b <- map$cmd4[i]
    ok <- !is.na(cmd3[[a]]) & !is.na(j4[[b]])
    round(mean(norm(cmd3[[a]][ok]) == norm(j4[[b]][ok])), 3)
}, numeric(1L))
low <- map[which(map$relation %in% c("same", "renamed") & (map$coverage < 0.9 | map$identical < 0.95)), ]
if (nrow(low)) {
    print(low)
    warning("the rows above are marked same/renamed but do not match well")
}

## ---- value maps -----------------------------------------------------------
## For recoded columns with a manageable number of levels, every observed
## (cMD 3 value, cMD 4 value) pair with its count.
values <- list()
for (i in which(map$relation %in% c("recoded", "renamed+recoded"))) {
    a <- map$cmd3[i]
    b <- strsplit(map$cmd4[i], ";", fixed = TRUE)[[1]][1]
    va <- norm(cmd3[[a]]); vb <- norm(j4[[b]])
    ok <- !is.na(va)
    if (length(unique(va[ok])) > 60) next
    tab <- as.data.frame(table(cmd3_value = va[ok], cmd4_value = vb[ok], useNA = "ifany"),
                         stringsAsFactors = FALSE)
    tab <- tab[tab$Freq > 0, ]
    tab <- tab[order(tab$cmd3_value, -tab$Freq), ]
    values[[a]] <- data.frame(cmd3_column = a, cmd3_value = tab$cmd3_value,
                              cmd4_column = b, cmd4_value = tab$cmd4_value,
                              n = tab$Freq, stringsAsFactors = FALSE)
}
values <- do.call(rbind, values)
rownames(values) <- NULL

## ---- condition map --------------------------------------------------------
conditions <- data.frame(
    study_name = cmd3$study_name,
    study_condition = norm(cmd3$study_condition),
    disease_cmd3 = norm(cmd3$disease),
    target_condition = norm(j4$target_condition),
    control = norm(j4$control),
    disease_cmd4 = norm(j4$disease),
    stringsAsFactors = FALSE
) |>
    count(study_name, study_condition, disease_cmd3, target_condition, control, disease_cmd4,
          name = "n") |>
    arrange(study_name, desc(n)) |>
    as.data.frame()

## ---- write ----------------------------------------------------------------
dir.create("inst/extdata", showWarnings = FALSE)
write.csv(map, "inst/extdata/cmd3_to_cmd4_columns.csv", row.names = FALSE)
write.csv(values, "inst/extdata/cmd3_to_cmd4_values.csv", row.names = FALSE)
write.csv(conditions, "inst/extdata/cmd3_to_cmd4_conditions.csv", row.names = FALSE)
print(table(map$relation))
