get_subsection <- function(resource_object) {
    resource_class <- class(resource_object)[1]
    if(grepl("^A|^E|^I|^O|^U", resource_class, ignore.case = TRUE)) {
        class_article <- "An"
    } else {
        class_article <- "A"
    }
    sample_number <- sample_number(resource_object)
    feature_number <- feature_number(resource_object)
    resource_bodysite <- unique(resource_object$bodysite)
    paste(class_article, resource_class, "with", sample_number, "and",
          feature_number, "specific to the", resource_bodysite, "bodysite")
}
