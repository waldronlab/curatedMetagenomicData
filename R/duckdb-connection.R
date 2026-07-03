### DuckDB catalog connection helpers (internal) -----------------------------
###
### Inlined from curatedCore::source.R. Since curatedMetagenomicData only
### ever connects to a DuckDB catalog, the multi-backend CuratedSource S4
### class and dispatch are replaced with a single .cmd_connect() function.

## ---- S3 endpoint configuration --------------------------------------------

## Configure the DuckDB httpfs S3 client for a catalog host.
## Parses scheme and host from a catalog URL and, for HTTP(S) catalogs,
## points DuckDB's httpfs S3 client at that host so the catalog's s3://
## view references resolve back to it.
##
## @param con A DuckDB connection.
## @param url character(1). The catalog URL.
## @return NULL, invisibly.
## @importFrom DBI dbExecute
.configure_s3 <- function(con, url) {
    scheme_match <- regmatches(
        url,
        regexpr("^(https?)://([^/]+)", url, ignore.case = TRUE)
    )
    if (length(scheme_match) == 1L) {
        parts <- regmatches(
            scheme_match,
            regexec("^(https?)://([^/]+)", scheme_match, ignore.case = TRUE)
        )[[1L]]
        scheme <- tolower(parts[2L])
        endpoint <- parts[3L]
        DBI::dbExecute(con, sprintf("SET s3_endpoint='%s';", endpoint))
        DBI::dbExecute(con, "SET s3_url_style='path';")
        DBI::dbExecute(
            con,
            sprintf("SET s3_use_ssl=%s;",
                if (scheme == "https") "true" else "false")
        )
    }
    invisible(NULL)
}

## ---- DuckDB catalog connection --------------------------------------------

## Open an in-memory DuckDB connection, install and load the httpfs
## extension, configure the S3 client for the catalog host, attach the
## catalog read-only, and USE it. This replaces the curatedCore pattern of
## duckdbCatalogSource() + connectSource() with a single direct call.
##
## @param db_url character(1). URL or path of the .duckdb catalog file.
## @param alias character(1). DuckDB alias for the attached catalog.
## @return An open DuckDB connection (DBIConnection).
## @importFrom DBI dbConnect dbExecute
## @importFrom duckdb duckdb
.cmd_connect <- function(db_url = .cmd_data_url(), alias = "cmgd") {
    con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")
    DBI::dbExecute(con, "INSTALL httpfs; LOAD httpfs;")
    .configure_s3(con, db_url)
    DBI::dbExecute(con, sprintf("ATTACH '%s' AS %s (READ_ONLY);",
        db_url, alias))
    DBI::dbExecute(con, sprintf("USE %s;", alias))
    con
}

## ---- DuckDB disconnect ----------------------------------------------------

## Disconnect and shut down a DuckDB connection. Wrapped in try() so it is
## safe to call on an already-closed connection.
##
## @param con A DuckDB connection.
## @return NULL, invisibly.
## @importFrom DBI dbDisconnect
.cmd_disconnect <- function(con) {
    suppressWarnings(
        try(DBI::dbDisconnect(con, shutdown = TRUE), silent = TRUE)
    )
    invisible(NULL)
}
