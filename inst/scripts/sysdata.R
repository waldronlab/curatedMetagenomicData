sysdata <- function(metadata) {
    if(file.exists("./R/sysdata.Rda")) {
        load("./R/sysdata.Rda")
        combined_metadata <- full_join(combined_metadata, metadata)
    } else {
        combined_metadata <- metadata
    }
    save(combined_metadata, file = "./R/sysdata.Rda", compress = "gzip")
}
