feature_number <- function(resource_object) {
    feature_number <- dims(resource_object)[1]
    if(feature_number > 1) {
        feature_noun <- "features"
    } else {
        feature_noun <- "feature"
    }
    prettyNum(feature_number, big.mark = ",") %>%
    paste(., feature_noun)
}
