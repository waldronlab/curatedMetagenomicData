#' Pipe Operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#'
#' @usage lhs \%>\% rhs
#'
#' @param lhs a value or the magrittr placeholder
#'
#' @param rhs a function call using the magrittr semantics
#'
#' @return The result of calling `rhs(lhs)`
#' @export
#'
#' @examples
#' curatedMetagenomicData("LiJ_20.+.marker_abundance", dryrun = FALSE) %>%
#'     mergeData()
#'
#' curatedMetagenomicData("LiJ_20.+.pathway_abundance", dryrun = FALSE) %>%
#'     mergeData()
#'
#' curatedMetagenomicData("LiJ_20.+.relative_abundance", dryrun = FALSE) %>%
#'     mergeData()
#'
#' @importFrom magrittr %>%
#'
#' @keywords internal
#' @rdname pipe
NULL
