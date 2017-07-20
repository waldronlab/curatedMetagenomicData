context("ExpressionSet2phyloseq")

test_that("ExpressionSet2phyloseq returns phyloseq class object", {
    test_object <-
        LomanNJ_2013.metaphlan_bugs_list.stool() %>%
        ExpressionSet2phyloseq()

    expect_is(test_object, "phyloseq")
})

test_that("ExpressionSet2phyloseq works with phylogenetictree = TRUE", {
    library(phyloseq)
    test_object <-
        LomanNJ_2013.metaphlan_bugs_list.stool() %>%
        ExpressionSet2phyloseq(., phylogenetictree = TRUE)
    expect_is(test_object, "phyloseq")
    expect_equal(dim(otu_table(test_object)) , c(140, 43))
    expect_true(is(phy_tree(test_object), "phylo"))
})

test_that("ExpressionSet2phyloseq returns the same numerical data with simplify=TRUE/FALSE", {
    library(phyloseq)
    eset <- LomanNJ_2013.metaphlan_bugs_list.stool()
    pseq1 <- ExpressionSet2phyloseq(eset, relab = TRUE, phylogenetictree = TRUE, simplify = TRUE)
    pseq2 <- ExpressionSet2phyloseq(eset, relab = TRUE, phylogenetictree = TRUE, simplify = FALSE)
    mat <- otu_table(pseq1) - otu_table(pseq2)
    expect_equal(max(abs(mat)), 0)
    tax1 <- tax_table(pseq1); rownames(tax1) <- NULL
    tax2 <- tax_table(pseq2); rownames(tax2) <- NULL
    expect_equal(tax1, tax2)
    expect_equal(sample_data(pseq1), sample_data(pseq2))
    tips1 <- phy_tree(pseq1)$tip.label
    tips2 <- sub(".+\\|", "", phy_tree(pseq2)$tip.label)
    expect_equal(tips1, tips2)
})
