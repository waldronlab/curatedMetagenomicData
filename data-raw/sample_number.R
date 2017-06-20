sample_number <- function(resource_object) {
    sample_number <- dims(resource_object)[2]
    if(sample_number == 1) {
        sample_noun <- "sample"
    } else {
        sample_noun <- "samples"
    }
    prettyNum(sample_number, big.mark = ",") %>%
    paste(., sample_noun)
}
