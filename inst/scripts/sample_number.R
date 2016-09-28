sample_number <- function(resource_object) {
    sample_number <- dims(resource_object)[2]
    if(sample_number > 1) {
        sample_noun <- "samples"
    } else {
        sample_noun <- "sample"
    }
    prettyNum(sample_number, big.mark = ",") %>%
    paste(., sample_noun)
}
