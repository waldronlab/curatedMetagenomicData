## The published cMD data release this package reads from -------------------
##
## curatedMetagenomicData 4 reads profiles from the public cMD releases at
## https://cmgd-public.cancerdatasci.org through the cmgdr package. A
## dataset is one pipeline registration (`<workflow_id>-<version>`), and a
## release is an immutable, dated snapshot of it. The package pins one
## dataset and one release so that results are reproducible for a given
## package version; both can be overridden with options for people who
## need a different one.

.cmd_default_dataset <- "cmgd_mpa4.2-2.3.0"
.cmd_default_release <- "2026-10-20"

.cmd_env <- new.env(parent = emptyenv())

#' The cMD data release in use
#'
#' curatedMetagenomicData 4 reads profiling data from the public
#' curatedMetagenomicData releases at
#' <https://cmgd-public.cancerdatasci.org>, through the
#' \pkg{cmgdr} package. A *dataset* is one pipeline registration (a pipeline
#' version plus its configuration), and a *release* is an immutable snapshot
#' of a dataset named by its build date. Each version of this package pins
#' one dataset and one release so that the same code returns the same data;
#' `cmdRelease()` returns the handle for that release, which is what
#' [curatedMetagenomicData()] and [returnSamples()] read from.
#'
#' To read a different dataset or release, set the options
#' `curatedMetagenomicData.dataset` and `curatedMetagenomicData.release`
#' before calling any data-access function, for example
#' `options(curatedMetagenomicData.release = "latest")`. Use
#' [cmgdr::cmgd_datasets()] and [cmgdr::cmgd_releases()] to see what is
#' published. Downloads are cached by \pkg{cmgdr} under
#' [cmgdr::cmgd_cache_dir()] and verified against the release's checksums.
#'
#' @param dataset dataset id, by default the pinned dataset
#' @param release release id, or `"latest"`; by default the pinned release
#'
#' @return a `cmgd_release` object from [cmgdr::cmgd_release()], with
#' elements `dataset`, `release`, `url` and `manifest`
#' @export
#'
#' @seealso [curatedMetagenomicData], [returnSamples]
#'
#' @examples
#' cmdRelease()
cmdRelease <- function(
    dataset = getOption("curatedMetagenomicData.dataset", .cmd_default_dataset),
    release = getOption("curatedMetagenomicData.release", .cmd_default_release)
) {
    key <- paste(dataset, release, sep = "/")
    rel <- .cmd_env[[key]]
    if (is.null(rel)) {
        rel <- cmgdr::cmgd_release(dataset, release = release)
        .cmd_env[[key]] <- rel
    }
    rel
}

.cmd_cache <- function() {
    getOption("curatedMetagenomicData.cache", cmgdr::cmgd_cache_dir())
}
