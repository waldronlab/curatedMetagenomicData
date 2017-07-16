context("ExpressionSet2phyloseq")

test_that("ExpressionSet2phyloseq returns phyloseq class object", {
    test_object <-
        LomanNJ_2013.metaphlan_bugs_list.stool() %>%
        ExpressionSet2phyloseq()

    expect_is(test_object, "phyloseq")
})

test_that("ExpressionSet2phyloseq works with phylogenetictree = TRUE", {
    test_object <-
        LomanNJ_2013.metaphlan_bugs_list.stool() %>%
        ExpressionSet2phyloseq(., phylogenetictree = TRUE)
    expect_is(test_object, "phyloseq")
    expect_equal(dim(otu_table(test_object)) , c(140, 43))
    expect_true(is(phy_tree(test_object), "phylo"))
})
