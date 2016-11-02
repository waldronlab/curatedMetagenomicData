get_DispatchClass <- function(resource_name) {
    if(is_rda(resource_name)) {
        return("Rda")
    }
}
