make_upload <- function() {
    create_dir("./exec")
    aws_prefix <- "aws s3 cp ../data/"
    aws_suffix <- "s3://experimenthub/curatedMetagenomicData/ --acl public-read"
    dir("./data") %>%
    paste(aws_prefix, ., aws_suffix) %>%
    cat(., file = "./exec/upload2AWS.sh", fill = TRUE)
}
