get_DispatchClasses <- function(ResourceName) {
    is_rda <- is_rda(ResourceName)
    if(all(is_rda)) {
        length(is_rda) %>%
        rep("Rda", .)
    }
}
