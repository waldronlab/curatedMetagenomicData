\name{utilities}

\alias{utilities}

\alias{availableResources}
\alias{filterResources}
\alias{loadResources}

\title{Utility functions for filtering and loading datasets in the
  \sQuote{curatedMetagenomicData} package
}

\description{
  Miscellaneous utility functions operating on the datasets associated
  with the \sQuote{curatedMetageniomicData} package.
}

\usage{
availableResources()
filterResources(bodysite = character(), study = character())
loadResources(bodysite = character(), study = character(),
              resources=character()))
}

\arguments{
  \item{bodysite}{
    A \code{character} vector of bodysites terms taken from the title
    of the resources. Used in filtering.
  }
  \item{study}{
    A \code{character} vector of study terms taken from the title of
    the resources. Used in filtering.
  }
  \item{resources}{
    A \code{character} vector of resource names; often the output of a call
    to \code{filterResources} or \code{availableResources}. Used in filtering.
  }
}

\details{
  The \code{availableResources} function returns a vector of names of all
  resources associated with the package.

  The \code{filterResources} function returns a vector of resource names
  filtered by \code{bodysite} and \code{study}. Valid \code{bodysite} and 
  \code{study} terms should be taken from the resource name seen in the 
  output of a call to \code{availableResources}). When both \code{bodysite} 
  and \code{study} terms are given the filter returns records that contain
  one or both terms.
 
  The \code{loadResources} function returns a list of \code{eSet} objects
  loaded in the R workspace. When the function is called with no arguments
  the output includes all resources related to the package. Filtering is
  applied when one or more of \code{bodysite}, \code{study} or 
  \code{resources} are given.
}

\value{
  \code{availableResources}:  a \code{character} vector of resource names.
 
  \code{filterResources}:  a \code{character} vector of resource names.

  \code{loadResources}: a list of \link[Biobase]{eSet} objects
}

\seealso{
}

\examples{
## List all resources associated with curatedMetagenomicData:
head(availableResources())

## Filter on 'stool' bodytype:
filterResources(bodytype="stool")
}

\keyword{methods}
