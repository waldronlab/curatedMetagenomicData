### DuckDB view query helpers (internal) -------------------------------------
###
### Inlined from curatedCore::query.R and curatedCore::validators.R.
### All functions are internal (not exported, dot-prefixed). The SchemaSpec
### parameter is dropped; CMD hardcodes its id_col via cmd4_data_types.csv.

## ---- input validators -----------------------------------------------------

## Validate a DuckDB connection object.
## @param con Object to validate.
## @return NULL, invisibly. Throws an error if con is not a DuckDB connection.
## @noRd
.confirm_duckdb_con <- function(con) {
    if (!methods::is(con, "duckdb_connection")) {
        stop("Please provide a valid 'duckdb_connection' object.",
            call. = FALSE)
    }
    invisible(NULL)
}

## Validate a DuckDB lazy view/table object.
## @param view Object to validate.
## @return NULL, invisibly.
## @noRd
.confirm_duckdb_view <- function(view) {
    if (!methods::is(view, "tbl_duckdb_connection")) {
        stop("Please provide a valid object of the class ",
            "'tbl_duckdb_connection'.", call. = FALSE)
    }
    invisible(NULL)
}

## Validate a filter_values argument.
## @param filter_values A named list (column to values) or NULL.
## @return NULL, invisibly. Throws an error if invalid.
## @noRd
.confirm_filter_values <- function(filter_values) {
    if (!is.null(filter_values) &&
        (!is.list(filter_values) || is.null(names(filter_values)))) {
        stop("'filter_values' must be a named list of column = values",
            call. = FALSE)
    }
    invisible(NULL)
}

## ---- projection selection -------------------------------------------------

## Choose the most appropriate DuckDB view for a feature.
##
## Given a connection, a base view name, and an optional feature/id column
## to filter by, return the name of the most appropriate available view.
## When a projection named <base>_<feature> exists it is preferred;
## otherwise a view containing the id_col is used, falling back to the
## base view itself.
##
## @param con A DuckDB connection.
## @param view_name character(1). Base view name for a data type.
## @param feature character(1) or NULL. Feature/column to sort by.
## @param id_col character(1). Canonical sample-identity column.
## @return character(1). The chosen view name.
## @importFrom DBI dbListTables
## @noRd
.pick_projection <- function(con, view_name, feature = NULL,
                             id_col = "sample_name") {
    .confirm_duckdb_con(con)
    tbs <- DBI::dbListTables(con)

    matching <- tbs[tbs == view_name |
        startsWith(tbs, paste0(view_name, "_"))]
    if (length(matching) == 0L) {
        stop("'", view_name, "' does not match any existing views.",
            call. = FALSE)
    }

    if (!is.null(feature)) {
        eview <- paste0(view_name, "_", feature)
        if (eview %in% matching) {
            return(eview)
        }
    }

    if (view_name %in% matching) {
        return(view_name)
    }
    id_views <- matching[grepl(id_col, matching)]
    if (length(id_views) > 0L) {
        return(id_views[1L])
    }
    matching[1L]
}

## ---- lazy filtering -------------------------------------------------------

## Filter a DuckDB view, pushing predicates down to DuckDB.
##
## Given a connection and the base view name for a data type, selects an
## appropriate projection (via .pick_projection()) and applies an ordered
## set of exact filters. Filters are applied most-selective-first, and the
## first column is filtered using the union_all optimization to encourage
## index/partition pruning. The result is a lazy tbl; nothing is
## materialized until .collect_view().
##
## @param con A DuckDB connection.
## @param view_name character(1). Base view name for a data type.
## @param filter_values Named list (column to exact values) or NULL.
## @return A lazy tbl_duckdb_connection object.
## @importFrom dplyr tbl filter union_all collapse
## @importFrom rlang sym
## @noRd
.filter_view <- function(con, view_name, filter_values = NULL) {
    .confirm_duckdb_con(con)
    .confirm_filter_values(filter_values)

    if (is.null(filter_values) || length(filter_values) == 0L) {
        projection <- .pick_projection(con, view_name)
        return(dplyr::tbl(con, projection))
    }

    ## Order filter columns by selectivity (fewest values first).
    lengths <- vapply(filter_values, length, integer(1L))
    if (any(lengths == 0L)) {
        projection <- .pick_projection(con, view_name)
        return(dplyr::filter(dplyr::tbl(con, projection), FALSE))
    }
    sorted_inds <- order(lengths)
    sorted_args <- filter_values[sorted_inds]

    projection <- .pick_projection(con, view_name,
        feature = names(sorted_args)[1L])
    view <- dplyr::tbl(con, projection)

    col_order <- names(sorted_args)
    first_col <- col_order[1L]
    first_vals <- sorted_args[[first_col]]

    if (length(first_vals) == 1L) {
        result <- dplyr::filter(view,
            !!rlang::sym(first_col) == first_vals) |>
            dplyr::collapse()
        remaining_cols <- setdiff(col_order, first_col)
    } else if (length(first_vals) <= 10L) {
        parts <- lapply(first_vals, function(val) {
            dplyr::filter(view, !!rlang::sym(first_col) == val)
        })
        result <- Reduce(dplyr::union_all, parts)
        remaining_cols <- setdiff(col_order, first_col)
    } else {
        result <- view
        remaining_cols <- col_order
    }

    for (col in remaining_cols) {
        vals <- sorted_args[[col]]
        if (length(vals) == 1L) {
            result <- dplyr::filter(result, !!rlang::sym(col) == vals)
        } else {
            result <- dplyr::filter(result, !!rlang::sym(col) %in% vals)
        }
    }

    result
}

## ---- collection -----------------------------------------------------------

## Collect a lazy DuckDB view into a tibble.
##
## Materializes a lazy tbl with dplyr::collect(). When notify is TRUE, a
## generic message is emitted if the pull is large, since collecting many
## rows (especially over a network) can be slow.
##
## @param lazy A lazy tbl_duckdb_connection object.
## @param notify logical(1). Emit a message for large pulls.
## @return A tibble.
## @importFrom dplyr collect
## @noRd
.collect_view <- function(lazy, notify = TRUE) {
    .confirm_duckdb_view(lazy)
    collected <- dplyr::collect(lazy)
    if (isTRUE(notify) && nrow(collected) > 1e6L) {
        message("Collected ", nrow(collected), " rows; large pulls can be ",
            "slow and memory-intensive, especially over a network.")
    }
    collected
}
