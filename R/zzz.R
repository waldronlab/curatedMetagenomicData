#' @importFrom utils read.csv
#' @importFrom magrittr %>%
#' @importFrom dplyr arrange
#' @importFrom dplyr desc
#' @importFrom dplyr distinct
#' @importFrom dplyr mutate
#' @importFrom magrittr %$%
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
    split_titles <- strsplit(titles, "\\.")
    subset_titles <- sapply(split_titles, function(x) {length(x) == 4})
    title_df <- data.frame(t(sapply(split_titles[subset_titles], c)))
    colnames(title_df) <- c("run_date", "study", "data_type", "body_site")

    titles <- character()
    dates <- integer()

    title_df %>%
        arrange(desc(run_date), study, data_type, body_site) %>%
        distinct(study, data_type, body_site, .keep_all = TRUE) %>%
        mutate(run_date = as.character(run_date)) %>%
        mutate(run_date = as.integer(run_date)) %$% {
            titles <<- paste(study, data_type, body_site, sep =".")
            dates <<- run_date
        }

    ## Functions to load resources by name:
    ns <- asNamespace(pkgname)
    mapply(function(xx, yy) {
        func = function(cmdversion = yy, metadata = FALSE) {
            ## Deprecate munged dataset names, introduced for Bioc 3.8 release Oct 2018
            deprecation.regex <- "Castro_NallarE|Heitz_BuschartA|Obregon_TitoAJ"
            if(grepl(deprecation.regex, xx)){
                .Deprecated(sub("_", "-", xx))
            }
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
                            " not found in ExperimentHub\n",
                            "Try a different cmdversion, see",
                            " cmdValidVersions() for possible values"))
            if (metadata)
                eh[ehid]
            else eh[[ehid]]
        }
        assign(xx, func, envir = ns)
        namespaceExport(ns, xx)
    }, xx = titles, yy = dates)

    globalVariables(".")
    globalVariables("body_site")
    globalVariables("data_type")
    globalVariables("run_date")
    globalVariables("study")
}

.onAttach <- function(libname, pkgname) {
    system.file("extdata", "curatedMetagenomicData.txt",
                package = "curatedMetagenomicData") %>%
        readLines() %>%
        paste0(collapse = "\n") %>%
        packageStartupMessage()
}
