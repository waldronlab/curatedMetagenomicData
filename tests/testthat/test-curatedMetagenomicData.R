context("curatedMetagenomicData")

test_that("Does curatedMetagenomicData work?", {
    ## studies from curatedMetagenomicData()
    allds <- curatedMetagenomicData("*", dryrun = TRUE)
    allstudies.cmd <- sub("\\..+", "", allds) %>%
        unique %>%
        sort %>%
        grep("WenC_2017", ., invert = TRUE, value = TRUE)
    ## studies from combined_metadata
    data("combined_metadata")
    allstudies.combined_metadata <- unique(combined_metadata$dataset_name) %>% sort
    ## studies from inst/extdata/metadata.csv
    filename <- system.file("extdata/metadata.csv", package="curatedMetagenomicData")
    allstudies.metadata.csv <- read.csv(filename, as.is = TRUE)$Title %>%
        grep("^201804", ., invert = TRUE, value = TRUE) %>%
        sub("^[0-9]+\\.", "", .) %>%
        sub("\\..+", "", .) %>%
        unique %>%
        sort %>%
        grep("WenC_2017", ., invert = TRUE, value = TRUE)
    ## compare curatedMetagenomicData() to combined_metadata
    extrastudies1 <- paste(setdiff(allstudies.cmd, allstudies.combined_metadata), collapse=" ")
    extrastudies2 <- paste(setdiff(allstudies.combined_metadata, allstudies.cmd), collapse=" ")
    expect_identical(allstudies.cmd, allstudies.combined_metadata,
                 info = paste("curatedMetagenomicData() and combined_metadata return the same datasets\n",
                              "in curatedMetagenomicData() but not combined_metadata: ", extrastudies1,
                              "\n in combined_metadata but not curatedMetagenomicData(): ", extrastudies2,
                              collapse=""))
    ## compare inst/extdata/metadata.csv to combined_metadata
    extrastudies3 <- paste(setdiff(allstudies.metadata.csv, allstudies.combined_metadata), collapse=" ")
    extrastudies4 <- paste(setdiff(allstudies.combined_metadata, allstudies.metadata.csv), collapse=" ")
    expect_identical(allstudies.metadata.csv, allstudies.combined_metadata,
                 info = paste("inst/extdata/metadata.csv and combined_metadata have the same datasets",
                              "\n in inst/extdata/metadata.csv but not combined_metadata: ", extrastudies3,
                              "\n in combined_metadata but not inst/extdata/metadata.csv: ", extrastudies4,
                              collapse=""))
    ## check for munged dataset names
    checkMunging <- function(x, msg){
        munged <- grep("^[A-Za-z]+_[A-Za-z]", x, value = TRUE)
        expect_false(length(munged) > 0,
                     info = paste("Munged datasets in", msg, ":", paste(munged, collapse=" "), collapse = " "))
    }
    checkMunging(allstudies.combined_metadata, "combined_metadata")
    checkMunging(allstudies.cmd, "curatedMetagenomicData()")
    checkMunging(allstudies.metadata.csv, "inst/extdata/metadata.csv")
    ## Check that every dataset 6 data products
    ## number of  data products per study
    nproducts <- strsplit(allds, "\\.") %>%
        sapply(., function(x) paste(x[c(1, 3)], collapse=".")) %>%
        table()
    not6products <- nproducts[nproducts != 6]
    expect_true(length(not6products)==0,
                info = paste(names(not6products), not6products, sep=": "))
})

test_that("BritoIL_2016 and Castro-NallarE", {
    oral <- c("BritoIL_2016.metaphlan_bugs_list.oralcavity",
              "Castro-NallarE_2015.metaphlan_bugs_list.oralcavity")
    esl <- curatedMetagenomicData(oral, dryrun = FALSE, counts=TRUE)
    expect_equal(length(esl), 2L)
    expect_equal(names(esl), oral)
    brito <- BritoIL_2016.metaphlan_bugs_list.oralcavity()
    brito.counts = sweep(exprs( brito ), 2, brito$number_reads / 100, "*")
    brito.counts = round(brito.counts)
    expect_equal(exprs(esl[[1]]), brito.counts)
    pseq <- curatedMetagenomicData(oral[1], bugs.as.phyloseq = TRUE,
                                   counts = TRUE, dryrun = FALSE)
    expect_equal(ExpressionSet2phyloseq(esl[[1]]), pseq[[1]])
})
