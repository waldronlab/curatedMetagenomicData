#' @importFrom utils read.csv
#' @importFrom AnnotationHub query
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom utils globalVariables
#' @importFrom methods is
#' @importFrom Biobase isUnique
#' @keywords internal
.onLoad <- function(libname, pkgname) {
    titles <- read.csv(system.file("extdata", "metadata.csv",
                                   package="curatedMetagenomicData"),
                       stringsAsFactors=FALSE)$Title
    latest_version <- max(gsub("([^0-9])\\w+", "", titles))
    versioned_titles <- titles[startsWith(titles, latest_version)]
    rda <- gsub(".rda", "", versioned_titles, fixed=TRUE)
    rda <- gsub(paste0(latest_version, "\\."), "", versioned_titles)
    if (!length(rda))
        stop("no .rda objects found in metadata")

    ## Functions to load resources by name:
    ns <- asNamespace(pkgname)
    sapply(rda,
           function(xx) {
               func = function(cmdversion = latest_version, metadata = FALSE) {
                   cmdversion <- as.integer(cmdversion)
                   if(length(cmdversion) > 1 | !.cmdIsValidVersion(cmdversion))
                       stop("Must provide a single valid version number, see
                            cmdValidVersions().")
                   if (!isNamespaceLoaded("ExperimentHub"))
                       attachNamespace("ExperimentHub")
                   eh <- query(ExperimentHub(), "curatedMetagenomicData")
                   ehid <- names(query(eh, paste0(cmdversion, ".", xx)))
                   if (!length(ehid))
                       stop(paste0("resource ", xx,
                                   " not found in ExperimentHub"))
                   if (metadata)
                       eh[ehid]
                   else eh[[ehid]]
               }
               assign(xx, func, envir=ns)
               namespaceExport(ns, xx)
           })

    globalVariables(".")

    readLines("./inst/extdata/curatedMetagenomicData.txt") %>%
        paste0(collapse = "\n") %>%
        message()

    message("Consider using the development version of curatedMetagenomicData,",
            "\n",
            "as the database has expanded considerably since the last release.",
            "\n", "See tinyurl.com/datasets-included for further information.")
}

