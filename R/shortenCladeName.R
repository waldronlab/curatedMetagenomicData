.shortenCladeName <- function #Shorten Maaslin-compliant or QIIME-compliant taxonomical clade names
### Keeps only the last informative bit (containing a __, plus taxid
### integer if present), for nicer plotting.
### Function by Levi Waldron.
(x,
 ### A vector of QIIME taxonomic names, pipe-separated.
 separator="|"
 ### The character used to separate levels of the taxonomy: ";" for QIIME, "|" for Maaslin.
){
  split.names <- strsplit(x, separator, fixed=TRUE)
  sapply(1:length(split.names), function(i){
    if (sum(grepl("__", split.names[[i]])) == 0){
      return(x[i])
    }else{
      return(paste(split.names[[i]][max(grep("__", split.names[[i]])):length(split.names[[i]])], collapse="|"))
    }})
  ### a vector the same length as x, providing only the leaf-level
  ### names of the taxonomy.
}
