context("curatedMetagenomicData")

test_that("curatedMetagenomicData works", {
    allds <- curatedMetagenomicData("*", dryrun = TRUE)
    allstudies1 <- sub("\\..+", "", allds) %>%
        unique %>%
        sort
    data("combined_metadata")
    allstudies2 <- unique(combined_metadata$dataset_name) %>% sort
    expect_equal(allstudies1, allstudies2) #cMD and combined_metadata match
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
