test_that("phyloseq class object is not null", {
  stoolAbundance <- loadResources(ExperimentHub(), "curatedMetagenomicData",
                                  "Candela_Africa.stool.abundance.eset")[[1]]
  taxaAbundance <- exprs(stoolAbundance)
  phyloseqObject <- ExpressionSet2phyloseq(taxaAbundance, metadat = NULL,
                                           simplenames = TRUE,
                                           roundtointeger = FALSE)
  expect_is(phyloseqObject, "phyloseq")
  expect_gte(length(rownames(phyloseqObject@otu_table)), 1)
  expect_gte(length(colnames(phyloseqObject@otu_table)), 1)
})
