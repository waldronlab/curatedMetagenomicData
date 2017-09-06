add_version_number <- function() {
    current_date <-
        Sys.Date() %>%
        gsub("-", "", .)

    dir("./uploads") %>%
        for(i in .) {
            paste0("./uploads/", i) %>% {
                file.rename(., paste0("./uploads/", current_date, ".", i))
            }
        }

    write_file(current_date, "./inst/extdata/versions.txt", append = TRUE)
}
