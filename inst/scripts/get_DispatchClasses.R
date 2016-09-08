get_DispatchClasses <- function() {
    is_rda <- is_rda()
    if(all(is_rda)) {
        "Rda"
    }
}
