\name{eSet-utils}

\alias{eSet-utils}

\alias{availableResources}
\alias{filterResources}
\alias{createResourcesList}

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
createResourcesList(bodysite = character(), study = character(),
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
    to \code{filterResources} or \code{availableResources}.
  }
}

\details{
  The \code{availableResources} function returns a vector of names for all
  resources associated with the package.

  The \code{filterResources} function returns a vector of resource names
  filtered by \code{bodysite} and \code{study}. Valid \code{bodysite} and 
  \code{study} terms should be taken from the resource name seen in the 
  output of a call to \code{availableResources}). When both \code{bodysite} 
  and \code{study} terms are given, the filter is applied as an 'and' not
  an 'or'; successful records must meet all criteria in both \code{bodysite}
  and \code{study}.
 
  The \code{createResourcesList} function returns a list of \code{eSet}
  objects. When \code{resources} is given the output includes only the
  datasets specified in \code{resources}. If \code{resources} is not given
  the output consists of resources filtered by \code{bodysites} and 
  \code{study}.

}

\value{
  \code{availableResources}:  a vector of resource names.
 
  \code{filterResources}:  a vector of resource names.

  \code{createResourcesList}: a list of \link[Biobase]{eSet} objects
}

\seealso{
}

\examples{
}

\keyword{methods}
