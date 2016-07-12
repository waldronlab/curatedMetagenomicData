\name{ExpressionSet2phyloseq}
\alias{ExpressionSet2phyloseq}
\title{
ExpressionSet2phyloseq
}
\description{
A function for converting ExpressionSet class objects to phyloseq class objects.
}
\usage{
ExpressionSet2phyloseq(tax, metadat=NULL, simplenames=TRUE, 
                       roundtointeger=FALSE)
}
\arguments{
  \item{tax}{
    tax is a matrix or data.frame with the table of taxonomic abundances, rows are taxa, columns are samples
}
  \item{metadat}{
    metadat is an optional data.frame of specimen metadata, rows are samples, columns are variables
  }
  \item{simplenames}{
    if \code{simplenames = TRUE}, use only the most detailed level of taxa names in the final object
  }
  \item{roundtointeger}{
    if \code{roundtointeger = TRUE}, values will be rounded to the nearest integer
  }
}
\value{
returns a phyloseq class object
}
\author{
Levi Waldron, Lucas Schiffer
}
\seealso{
  \code{\link[phyloseq]{phyloseq}},
  \code{\link[Biobase]{ExpressionSet}}
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x) 
{
  }

load  

}
