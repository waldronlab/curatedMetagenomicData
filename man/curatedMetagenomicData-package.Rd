\name{curatedMetagenomicData-package}

\alias{curatedMetagenomicData-package}
\alias{curatedMetagenomicData}

\title{
  Taxonomic, functional, and gene marker abundance in samples collected 
  from different body sites available as \code{ExpressionSet} objects.
}

\description{
  Shotgun metagenomics sequencing can simultaneously profile bacteria, archeae,
  fungi, and viruses to the strain level, enabling us to better
  understand relationships between microbiota to human health.
  In this package we present a collection of relative abundance
  of taxa, marker datasets, and gene function  across 3000 samples 
  collected from various human body sites. The package contains two types of
  marker datasets:
  \itemize{
    \item \sQuote{_pres}: presence/absence of taxonomic markers 
    \item \sQuote{_ab}: abundance level of markers across samples
  }
  The data have been parsed into \code{ExpressionSet} objects and
  are available in the Bioconductor \code{ExperimentHub}.
}

\details{
  See the vignette for examples of using these data in differential
  gene expression analysis.

  browseVignettes("curatedMetagenomicData")

  Details of how these data were created are in the scripts/ directory
  of the source package.
}

\examples{
library(ExperimentHub)
hub <- ExperimentHub()
x <- query(hub, c("Metagenomics", "CancerData"))
x
\dontrun{
## download resource
x[[1]]
}

## Get the package name associated with a resource:
packageName <- package(x[1])
packageName

## Using the package name as a search term returns all records from
## the same package.
query(hub, "curatedMetagenomicData")
}

\keyword{utilities}
