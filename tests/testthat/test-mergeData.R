context("mergeData")

test_that("mergeData produces a correct result", {
    mat0 <- matrix(1:12, ncol = 3,
               dimnames = list(paste0("row", 1:4), paste0("col", 1:3)))
    pdat0 <- AnnotatedDataFrame(data.frame(var1 = letters[1:3],
                                           var2 = LETTERS[1:3]))
    rownames(pdat0) <- colnames(mat0)
    esl <- SimpleList(eset1 = ExpressionSet(mat0[1:3, 1:2], pdat0[1:2,]),
                   eset2 = ExpressionSet(mat0[2:4, 2:3], pdat0[2:3,]))
    eset <- mergeData(esl)
    corcols <-
        paste(c("eset1", "eset1", "eset2", "eset2"),
              c("col1", "col2", "col2", "col3"),
              sep = ":")
    expect_equal(colnames(eset), corcols)
    expect_equal(rownames(eset), rownames(mat0))
    expect_equal(all(exprs(eset)[1:3, 1:2] - exprs(esl[[1]]) == 0), TRUE)
    expect_equal(all(exprs(esl[[2]]) - exprs(eset)[2:4, 3:4] == 0), TRUE)
    expect_equal(colnames(pData(eset)), c("var1", "var2", "studyID"))
})

test_that("mergeData accepts only a list of ExpressionSet objects", {
    mat0 <- matrix(1:12, ncol = 3,
                   dimnames = list(paste0("row", 1:4), paste0("col", 1:3)))
    pdat0 <- AnnotatedDataFrame(data.frame(var1 = letters[1:3],
                                           var2 = LETTERS[1:3]))
    rownames(pdat0) <- colnames(mat0)
    esl <- SimpleList(eset1 = ExpressionSet(mat0[1:3, 1:2], pdat0[1:2,]),
                      df1 = data.frame(1:10, 11:20))
    expect_error(mergeData(esl))
})

test_that("mergeData requires unique list element names", {
    mat0 <- matrix(1:12, ncol = 3,
                   dimnames = list(paste0("row", 1:4), paste0("col", 1:3)))
    pdat0 <- AnnotatedDataFrame(data.frame(var1 = letters[1:3],
                                           var2 = LETTERS[1:3]))
    rownames(pdat0) <- colnames(mat0)
    esl <- SimpleList(eset1 = ExpressionSet(mat0[1:3, 1:2], pdat0[1:2,]),
                      eset1 = ExpressionSet(mat0[2:4, 2:3], pdat0[2:3,]))
    expect_error(mergeData(esl))
})

test_that("mergeData requires unique column names", {
    mat0 <- matrix(1:12, ncol = 3,
                   dimnames = list(paste0("row", 1:4), paste0("col", 1:3)))
    pdat0 <- AnnotatedDataFrame(data.frame(var1 = letters[1:3],
                                           var1 = LETTERS[1:3]))
    rownames(pdat0) <- colnames(mat0)
    esl <- SimpleList(eset1 = ExpressionSet(mat0[1:3, 1:2], pdat0[1:2,]),
                      eset1 = ExpressionSet(mat0[2:4, 2:3], pdat0[2:3,]))
    expect_error(mergeData(esl))
})
