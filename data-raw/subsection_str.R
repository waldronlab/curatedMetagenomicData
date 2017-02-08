subsection_str <- function(subsection_name, subsection_text) {
    paste0("\n#' \\subsection{", subsection_name, "}{", "\n#'    ",
           subsection_text, "\n#' }\n#'")
}
