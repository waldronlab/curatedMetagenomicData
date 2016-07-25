.onLoad <- function(libname, pkgname)
{
    esets <- read.csv(system.file("extdata", "metadata.csv", 
                      package="curatedMetagenomicData"), 
                      stringsAsFactors=FALSE)$Title
    esets <- gsub(".rda", "", esets, fixed=TRUE)
    if (!length(esets))
        stop("no eSet objects found")
 
    ## Functions to load esets by name:
    ns <- asNamespace(pkgname)
    sapply(esets, 
        function(xx) {
            func = function(metadata = FALSE) {
                if (!isNamespaceLoaded("ExperimentHub"))
                    attachNamespace("ExperimentHub")
                eh <- query(ExperimentHub(), "curatedMetagenomicData")
                ehid <- names(query(eh, xx))
                if (!length(ehid))
                    stop(paste0("resource ", xx, 
                         "not found in ExperimentHub"))
                if (metadata)
                    eh[ehid]
                else eh[[ehid]]
            }
            assign(xx, func, envir=ns)
            namespaceExport(ns, xx)
        })
}
