context("curatedMetagenomicData")

test_that("curatedMetagenomicData works", {
    allds <- curatedMetagenomicData("*", dryrun = TRUE)
    allstudies1 <- sub("\\..+", "", allds) %>%
        unique %>%
        sort
    data("combined_metadata")
    allstudies2 <- unique(combined_metadata$dataset_name) %>% sort
    munged_combined_metadata <- grep("^[A-Za-z]+_[A-Za-z]", allstudies2, value = TRUE)
    expect_false(length(munged_combined_metadata) > 0,
                  info = paste("Munged datasets in combined_metadata$dataset_name: ",
                               munged_combined_metadata, collapse = " "))
    extrastudies1 <- paste(allstudies1[!allstudies1 %in% allstudies2], collapse=" ")
    extrastudies2 <- paste(allstudies2[!allstudies2 %in% allstudies1], collapse=" ")
    expect_equal(allstudies1, allstudies2,
                 info = paste("curatedMetagenomicData() and combined_metadata return the same datasets\n",
                              "in curatedMetagenomicData() but not combined_metadata: ", extrastudies1,
                              "\n in combined_metadata but not curatedMetagenomicData(): ", extrastudies2,
                              collapse=""))
    datatypes <- c("pathcoverage", "pathabundance_relab", "metaphlan_bugs_list",
                   "marker_presence", "marker_abundance", "genefamilies_relab") %>%
        paste(., collapse="|")
    allstudies3 <- sub(datatypes, "", allds) %>% unique
    expect_equal(length(allds), length(allstudies3) * 6) #6 data products per study
    expect_true(all(grepl(datatypes, allds))) #all datasets are of known data type
    ##
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
