utils::globalVariables(c("sampleMetadata"))
#' Merge a list of curatedMetagenomicData datasets
#'
#' \code{mergeData} merges a list of SummarizedExperiment-class objects produced by the
#' \code{curatedMetagenomicData} function into a single SummarizedExperiment-class object. It is
#' recommended to use this functions only on a list of datasets of the same
#' data type (for example, all relative_abundance datasets).
#'
#' @param obj
#' A list or SimpleList containing a SummarizedExperiment-class object in each element.
#' @param sampledelim
#' If a character vector of length one is provided, for example ":" (default) then
#' sample names in the merged SummarizedExperiment-class object will combine study
#' identifier with sample identifier in the form studyID:sampleID.
#' If not a character vector of length one, then sample names from the original
#' studies will be preserved. Can be set to NULL to keep the sample names of the
#' original studies.
#' @param studycolname
#' If a character vector of length one is provided (default: studyID), a column with this
#' name will be added to the colData, containing study IDs taken from
#' the names of the SummarizedExperiment-class object.
#'
#' @return a SummarizedExperiment-class object
#'
#' @importFrom Biobase isUnique
#' @importFrom SummarizedExperiment assay
#' @importFrom SummarizedExperiment colData
#' @importFrom SummarizedExperiment SummarizedExperiment
#' @importFrom methods is
#' @importFrom S4Vectors SimpleList
#'
#' @export

#' @examples
#' library(curatedMetagenomicData)
#' library(SummarizedExperiment)
#'
#' resources <- curatedMetagenomicData(pattern = "AsnicarF.*relative_abundance", dryrun = TRUE)
#' data_sets <- lapply(resources, function(x) curatedMetagenomicData(x, print = FALSE, dryrun = FALSE))
#' names(data_sets) <- gsub("^.*\\.(.*)\\..*$", "\\1", resources)
#'
#' merged_data_sets <- mergeData(data_sets)
#' merged_data_sets
#'
#' relative_abundance <- assays(merged_data_sets)$relative_abundance
#' relative_abundance[1:10, 1:10]
#'
#' metadata <- colData(merged_data_sets)
#' metadata

mergeData <-
    function(obj,
             sampledelim = ":",
             studycolname = "studyID") {
        if(!is(obj, "list") & !is(obj, "SimpleList"))
            stop("obj should be a list.")
        if(!all(sapply(obj, function(x) is(x, "SummarizedExperiment")))){
            stop("all elements of obj should be SummarizedExperiment objects")
        }
        if(!is(names(obj), "character") & !all(Biobase::isUnique(names(obj)))){
            stop("obj should be a named list with unique names.")
        }
        mat <-
            joinListOfMatrices(lapply(obj, SummarizedExperiment::assay),
                               columndelim = sampledelim)
        pdat <-
            joinListOfDFs(lapply(obj, SummarizedExperiment::colData),
                          rowdelim = sampledelim)
        pdat <- pdat[match(colnames(mat), rownames(pdat)), ]
        se <-
            SummarizedExperiment::SummarizedExperiment(
                assays = S4Vectors::SimpleList(relative_abundance = mat),
                rowData = NULL,
                colData = pdat,
                metadata = NULL
                )
        return(se)
    }

joinListOfMatrices <- function(obj, columndelim = ":") {
    rnames <- Reduce(union, lapply(obj, rownames))
    if (is(columndelim, "character")) {
        for (i in seq_along(obj)) {
            colnames(obj[[i]]) <-
                paste(names(obj)[i], colnames(obj[[i]]), sep = columndelim)
        }
    }
    cnames <- unlist(lapply(obj, colnames))
    names(cnames) <- NULL
    if (!all(Biobase::isUnique(cnames))) {
        stop("Column names are not unique. Set columndelim to a character value")
    }
    output <- matrix(0,
                     nrow = length(rnames),
                     ncol = length(cnames),
                     dimnames = list(rnames, cnames)
    )
    for (i in seq_along(obj)) {
        output[match(rownames(obj[[i]]), rownames(output)),
               match(colnames(obj[[i]]), colnames(output))] <-
            obj[[i]]
    }
    return(output)
}

joinListOfDFs <-
    function(obj,
             rowdelim = ":",
             addstudycolumn = "studyID") {
        for (i in seq_along(obj)) {
            if (is(rowdelim, "character")) {
                rownames(obj[[i]]) <-
                    paste(names(obj)[i], rownames(obj[[i]]), sep = rowdelim)
            }
            obj[[i]]$mergedsubjectID <- rownames(obj[[i]])
        }
        FUN = function(x, y) merge(x, y, all=TRUE)
        bigdf <- Reduce(FUN, obj)
        rownames(bigdf) <- bigdf$mergedsubjectID
        if (is(addstudycolumn, "character")) {
            bigdf[[addstudycolumn]] <- sub(paste0(rowdelim, ".+"), "", bigdf$mergedsubjectID)
        }
        bigdf <- bigdf[, -match("mergedsubjectID", colnames(bigdf))]
        return(bigdf)
    }
