make_upload <- function() {
    create_dir("./exec")
    append <- file.exists("./exec/upload2AWS.sh")
    aws_prefix <- "aws s3 cp ../uploads/"
    aws_suffix <- " s3://experimenthub/curatedMetagenomicData/ --acl public-read"
    dir("./uploads") %>%
    paste0(aws_prefix, ., aws_suffix) %>%
    cat(., file = "./exec/upload2AWS.sh", fill = TRUE, append = append)
}
