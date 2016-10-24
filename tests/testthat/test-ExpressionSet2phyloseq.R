test_that("ExpressionSet2phyloseq returns phyloseq class object", {
    LomanNJ_2013_Mi.metaphlan_bugs_list.stool() %>%
    ExpressionSet2phyloseq() %>%
    class() %>%
    expect_equal("phyloseq")
})
