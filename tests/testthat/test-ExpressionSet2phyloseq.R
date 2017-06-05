context("ExpressionSet2phyloseq")

test_that("ExpressionSet2phyloseq returns phyloseq class object", {
    test_object <-
        LomanNJ_2013_Mi.metaphlan_bugs_list.stool() %>%
        ExpressionSet2phyloseq()

    expect_is(test_object, "phyloseq")
})
