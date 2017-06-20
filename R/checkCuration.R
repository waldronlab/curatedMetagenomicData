

#' Title Check the curation of per-participant metadata against a template.
#'
#' @param curated a data.frame containing the curated per-participant metadata to be checked
#' @param template a data.frame defining valid syntax
#'
#' @return a list with two elements, [["colnames"]] and [["values]]
#' @export checkCuration
#' @details See Examples for the template used for curatedMetagenomicData. The template data.frame must have five columns:
#'
#' 1. "col.name" specifies the name of the column in the curated data.frame.
#'
#' 2. "var.class": the class the variable must be, e.g. character, numeric, integer
#'
#' 3. "uniqueness": unique means each value must be unique, non-unique means repeated values are allowed
#'
#' 4. "requiredness": if "required", there must be no missing (NA) values. If "optional", missing values are allowed.
#'
#' 5. "allowedvalues" can be a regex or one of the following shorthands:
#' \describe{
#'   \item{decimal}{"^[0-9]+\\.?[0-9]*$" (there *may* be a decimal)}
#'   \item{decimalonly}{"^[0-9]+\\.{1}[0-9]*$" (there *must* be a decimal)}
#'   \item{integer}{"^[0-9]+$" (integer only, no decimals allowed)}
#'   \item{*}{"." (anything is allowed)}
#' }
#'
#' @examples
#' eset <- curatedMetagenomicData("ZellerG_2014.metaphlan_bugs_list.stool", dryrun=FALSE)[[1]]
#' checkCuration(eset)
#' data(combined_metadata)
#' checkCuration(combined_metadata)
#' \dontrun{
#' View(template)
#' }
#' data(combined_metadata)
#' problems <- checkCuration(curated=data.frame(combined_metadata),
#' template=template)
#' \dontrun{
#' View(problems$values)
#' }
checkCuration <- function(curated,
                          template = read.csv(system.file("extdata/template.csv",
                                                          package = "curatedMetagenomicData"),
                                              as.is = TRUE)) {
    problems <- list(colnames = NULL, values = NULL)
    if (is(curated, "ExpressionSet"))
        curated <- pData(curated)
    ##-------------------------------------------------
    ##check that the column names match the template
    ##-------------------------------------------------
    if (identical(all.equal(colnames(curated), template$col.name), TRUE)) {
        message("column names OK")
    } else{
        if (length(colnames(curated)) != template$col.name) {
            warning(
                paste(
                    "There are",
                    ncol(curated),
                    "columns in curated, but",
                    nrow(template),
                    "columns defined by template."
                )
            )
        } else{
            warning(
                "Type `View(problems$colnames)` to find mis-matched column names, assuming output of the function is named `problems`"
            )
            x <- colnames(curated)
            x[!x == template$col.name] <-
                paste0("!!!", x[!x == template$col.name], "!!!")
            problems$colnames <-
                cbind(x, template$col.name)
            colnames(problems$colnames) <- c("curated", "template")
        }
    }
    ##-------------------------------------------------
    ##construct the regexes from template$allowedvalues
    ##-------------------------------------------------
    regexes <- template$allowedvalues
    regexes <- paste("^", regexes, "$", sep = "")
    regexes <- gsub("|", "$|^", regexes, fixed = TRUE)
    ##regexes[template$requiredness=="optional"] <- paste(regexes[template$requiredness=="optional"],"|^NA$",sep="")
    regexes[grepl("^*$", regexes, fixed = TRUE)] <- "."
    names(regexes) <- template$col.name
    if (any(grepl("decimal", regexes)))
        regexes[grepl("decimal", regexes)] <- "^[0-9]+\\.?[0-9]*$"
    if (any(grepl("integer", regexes)))
        regexes[grepl("integer", regexes)] <- "^[0-9]+$"
    if (any(grepl("decimalonly", regexes)))
        regexes[grepl("decimalonly", regexes)] <-
        "^[0-9]+\\.{1}[0-9]*$"
    ##-------------------------------------------------
    ##Check the data entries in each column for regex
    ## matching, uniqueness, and missingness
    ##-------------------------------------------------
    ##check column names
    column.OK <- rep(NA, ncol(curated))
    names(column.OK) <- colnames(curated)
    for (j in seq_along(1:ncol(curated))) {
        doesmatch <- grep(regexes[j], curated[, j])
        if (template[j, "requiredness"] == "optional") {
            doesmatch <- c(doesmatch, which(is.na(curated[, j])))
        }
        doesnotmatch <- 1:nrow(curated)
        doesnotmatch <- doesnotmatch[!doesnotmatch %in% doesmatch]
        ## if field must be unique, add non-unique values to doesnotmatch
        if (template[j, "uniqueness"] == "unique") {
            counts.table <- table(curated[, j])
            counts <-
                counts.table[match(curated[, j], names(counts.table))]  #this counts the occurences
            counts[is.na(counts)] <- 1  ##Consider NAs to be unique
            nonunique <- which(counts > 1)
            doesnotmatch <- c(doesnotmatch, nonunique)
            doesnotmatch <-
                unique(doesnotmatch)  #don't duplicate fields that fail both tests
        }
        if (length(doesnotmatch) == 0) {
            column.OK[j] <- TRUE
        } else{
            warning(paste("Curation errors in column: ", colnames(curated)[j]))
            column.OK[j] <- FALSE
            curated[doesnotmatch, j] <-
                paste("!!!", curated[doesnotmatch, j], "!!!", sep = "")
        }
    }
    if (!all(column.OK)) {
        warning(
            "Type `View(problems$values)` and look for entries with !!!, assuming output of the function is named `problems`"
        )
        problems$values <- curated
    }
    return(problems)
}
