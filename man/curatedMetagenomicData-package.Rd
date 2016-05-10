\name{curatedMetagenomicData-package}

\alias{curatedMetagenomicData-package}
\alias{curatedMetagenomicData}

\title{
  Taxonomic, functional, and gene marker abundance in samples collected 
  from different body sites available as \code{ExpressionSet} objects.
}

\description{
  Human Microbiome has played a central role in clinical research due to its
  impact on human health and diseases. Shotgun metagenomics sequencing
  technology has provided a precise way to profile microbial diversity from
  various human body sites across different individuals, enabling us to better
  understand the relationship between specific microbiota to human health and
  some diseases.  In this package we present a collection of relative abundance
  of taxa across 3000 samples collected from various human body sites as well
  as relative abundance of marker datasets. The package contains two types of
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
