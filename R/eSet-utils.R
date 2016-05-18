### =========================================================================
### Miscellaneous helper/utility functions related to eSet discovery.
### -------------------------------------------------------------------------

availableResources <- function() { 
    read.csv(system.file("extdata", "metadata.csv", 
             package="curatedMetagenomicData"), 
             stringsAsFactors=FALSE)$Title

    ## FIXME: Alternatively ... 
    #eh <- ExperimentHub()
    #mcols(query(eh, "curatedMetagenomicData"))$Title
}

filterResources <- function(bodysite=character(), study=character()) {

    if (!is.character(bodysite))
        stop("'bodysite' must be a character vector")
    if (!is.character(study))
        stop("'study' must be a character vector")

    esets <- availableResources()
    idx <- logical(length(esets))
    if (length(bodysite))
        idx <- grepl(bodysite, esets, value=TRUE)
    ## FIXME: confirm that we want 'and' not 'or'
    if(length(study))
        idx <- grepl(study, esets, value=TRUE) & idx

    esets[idx]

    ## FIXME: Alternatively ... 
    #eh <- ExperimentHub()
    #mcols(query(eh, c(bodysite, study)))$Title
}

createResourcesList <- function(bodysite=character(), study=character(), 
                               resources=character()) { 

    if (length(resources) {
        if (!is.character(resources))
            stop("'resources' must be a character vector")
        if (length(bodysite))
            message("'bodysite' is ignored when 'resources' is given")
        if (length(study))
            message("'study' is ignored when 'resources' is given")
    } else {
        resources <- filterResources(bodysite, study)
    }

    ans <- lapply(resources, eval)
    names(ans) <- resources
    ans
}
