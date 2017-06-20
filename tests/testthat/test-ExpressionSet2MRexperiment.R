context("ExpressionSet2MRexperiment")

test_that("ExpressionSet2MRexperiment works", {
  library(metagenomeSeq)
  eset <- LomanNJ_2013.metaphlan_bugs_list.stool()
  mr1 <- ExpressionSet2MRexperiment(eset)
  mr2 <- ExpressionSet2MRexperiment(eset, simplify=FALSE)
  expect_is(mr1, "MRexperiment")
  expect_is(mr2, "MRexperiment")
  simplenames <- rownames(mr1)
  fullnames <- rownames(mr2)
  expect_equal(gsub(".+\\|", "", fullnames), simplenames)
  })
