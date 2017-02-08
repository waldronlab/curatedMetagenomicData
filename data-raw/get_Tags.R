get_Tags <- function(resource_name, resource_object) {
    tag_01 <- unique(resource_object$disease)
    tag_02 <- unique(resource_object$gender)
    tag_03 <- unique(resource_object$pubMedIds)
    tag_04 <- strsplit(resource_name, "\\.")[[1]][1]
    tag_05 <- strsplit(resource_name, "\\.")[[1]][2]
    tag_06 <- strsplit(resource_name, "\\.")[[1]][3]
    c(tag_01, tag_02, tag_03, tag_04, tag_05, tag_06) %>%
    paste(., collapse = ", ")
}
