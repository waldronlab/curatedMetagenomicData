#' Get valid data versions
#'
#' @return
#' An integer vector of data versions, in the format YYYYMMDD, read from inst/extdata/versions.txt.
#' @export cmdValidVersions
#' @importFrom utils read.table
#'
#' @examples
#' cmdValidVersions()
#' max(cmdValidVersions())  #latest version
#' stopifnot(is(cmdValidVersions(), "integer"))
cmdValidVersions <- function(){
    read.table(system.file("extdata/versions.txt", package = "curatedMetagenomicData"),
               as.is = TRUE)[, 1]
}

.cmdIsValidVersion <- function(vers, single.version=FALSE){
    is.valid <- TRUE
    if(!is(vers, "numeric")){
        warning("Version should be an integer, representing the date as YYYYMMDD")
        is.valid <- FALSE
    }
    if(single.version & !identical(length(vers), 1L)){
        warning("More than one version given with single.version=TRUE.")
        is.valid <- FALSE
    }
    if(!identical(length(vers), length(unique(vers)))){
        warning("Versions should not be repeated.")
        is.valid <- FALSE
    }
    if(!identical(vers %in% cmdValidVersions(), TRUE)){
        warning("Contains versions not returned by cmdValidVersions().")
        is.valid <- FALSE
    }
    return(is.valid)
}
