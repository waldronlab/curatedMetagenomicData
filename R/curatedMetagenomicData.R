#' @importFrom utils glob2rx
#' @importFrom S4Vectors "metadata<-"
#' @importClassesFrom S4Vectors SimpleList
#' @importFrom S4Vectors SimpleList
#'
#' @param x
#' A character vector of dataset names, regexes, or globs, that will be matched
#' to available datasets. If x.is.glob is TRUE (default), wildcards such as "*"
#' and "?" are supported (see ?glob2rx), otherwise, regexes are supported (see
#' ?grep)
#' @param counts = FALSE
#' If TRUE, relative abundances will be multiplied by read depth, then rounded to
#' the nearest integer.
#' @param bugs.as.phyloseq = FALSE
#' If TRUE, tables of taxonomic abundance (metaphlan datasets) will be converted
#' to phyloseq objects for use with the phyloseq package.
#' @param x.is.glob = TRUE
#' Set to FALSE to to treat x as a regular expression. If TRUE,
#' `x` is provided to \code{glob2rx} first to generate a regular expression.
#'
#' @param dryrun = TRUE
#' Only return the names of datasets to be downloaded, not the datasets
#' themselves. If FALSE, return the datasets rather than the names.
#'
#' @return
#' A list of ExpressionSet and/or phyloseq objects
#' @export
#' curatedMetagenomicData
#' @examples
#' curatedMetagenomicData()
#' curatedMetagenomicData("ZellerG*")
#' curatedMetagenomicData("ZellerG.+marker", x.is.glob=FALSE)
#' curatedMetagenomicData("ZellerG_2014.metaphlan_bugs_list.stool", dryrun=FALSE)
#' curatedMetagenomicData("ZellerG_2014.metaphlan_bugs_list.stool",
#'         counts=TRUE, dryrun=FALSE, bugs.as.phyloseq=TRUE)
curatedMetagenomicData <- function(x = "*",
                                   dryrun = TRUE,
                                   counts = FALSE,
                                   bugs.as.phyloseq = FALSE,
                                   x.is.glob = TRUE) {
    # cmdversion <- as.integer(cmdversion)
    # if(length(cmdversion) > 1 | !.cmdIsValidVersion(cmdversion))
        # stop("Must provide a single valid version number, see cmdValidVersions().")
    ## Deprecate munged dataset names, introduced for Bioc 3.8 release Oct 2018
    deprecation.regex <- "Bengtsson_PalmeJ|Castro_NallarE|Heitz_BuschartA|Obregon_TitoAJ"
    if(any(grepl(deprecation.regex, x))){
        .Defunct(new="curatedMetagenomicData",
                    msg="Use Bengtsson-PalmeJ instead of Bengtsson_PalmeJ,
                    Castro-NallarE instead of Castro_NallarE,
                    Heitz-BuschartA instead of Heitz_BuschartA,
                    and Obregon-TitoAJ instead of Obregon_TitoAJ")
    }
    requested.datasets <- x
    all.datasets <- ls("package:curatedMetagenomicData")
    all.datasets <-
        grep("marker|gene|path|metaphlan_bugs", all.datasets, value = TRUE)
    regex <-
        ifelse(x.is.glob,
               paste(glob2rx(requested.datasets), collapse = "|"),
               requested.datasets)
    matched.datasets <- grep(regex, all.datasets, value = TRUE)
    ## Don't wildcard match on munged dataset names
    matched.datasets <- grep("^[A-Za-z]+_[A-Za-z]", matched.datasets, invert = TRUE, value = TRUE)
    if (dryrun) {
        message(
            "Dry run: see return values for datasets that would be downloaded. ",
            "Run with `dryrun=FALSE` to actually download these datasets.")
        return(matched.datasets)
    }
    if (!any(matched.datasets %in% all.datasets))
        stop("requested datasets do not match any available datasets.")
    eset.list <- lapply(seq_along(matched.datasets), function(i) {
        message(paste0("Working on ", matched.datasets[i]))
        eset <- do.call(get(matched.datasets[i]), args = list())
        if (counts) {
            exprs(eset) <-
                round(sweep(exprs(eset), 2, eset$number_reads / 100, "*"))
        }
        if(bugs.as.phyloseq && grepl("metaphlan", matched.datasets[i])){
            eset <- ExpressionSet2phyloseq(eset)
        }
        return(eset)
    })
    eset.list <- S4Vectors::SimpleList(eset.list)
    # metadata(eset.list) <- list(cmdversion = cmdversion)
    names(eset.list) <- matched.datasets
    return(eset.list)
}
