#' @importFrom utils read.csv
#' @importFrom AnnotationHub query
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom utils globalVariables
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  titles <- read.csv(system.file("extdata", "metadata.csv",
                                 package="curatedMetagenomicData"),
                     stringsAsFactors=FALSE)$Title
  rda <- gsub(".rda", "", titles, fixed=TRUE)
  if (!length(rda))
    stop("no .rda objects found in metadata")

<<<<<<< HEAD
  ## Functions to load resources by name:
  ns <- asNamespace(pkgname)
  sapply(rda,
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
=======
    ## Functions to load resources by name:
    ns <- asNamespace(pkgname)
    sapply(rda,
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

    globalVariables(".")
>>>>>>> 701bedd03e55956a66f7dbe925581eef8a79c779
}
