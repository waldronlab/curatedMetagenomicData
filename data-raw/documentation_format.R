documentation_format <- function(template_csv) {
    load("./data/combined_metadata.Rda")
    nrow_combined_metadata <- nrow(combined_metadata)
    ncol_combined_metadata <- ncol(combined_metadata)
    colnames(combined_metadata) %>%
        match(template_csv$col.name) %>% {
            items <- template_csv$col.name[.]
            descriptions <-
                template_csv$description[.] %>%
                gsub("%", "\\\u5c\u25", .)
            paste0("\n#'   \\item{", items, "}{", descriptions, "}") %>%
                c("\n#' @format A data.frame with ", nrow_combined_metadata,
                    " rows and ", ncol_combined_metadata,
                    " variables:\n#' \\describe{", ., "\n#' }\n#'") %>%
                paste0(., collapse = "")
        }
}
