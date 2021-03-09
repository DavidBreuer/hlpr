testthat::context("onload / onLoad")

testthat::test_that("locale set to EN upon package loading", {
  en <- "en_US.UTF-8"
  .onLoad()
  testthat::expect_equal(Sys.getlocale(category = "LC_CTYPE"), en)
  testthat::expect_equal(Sys.getlocale(category = "LC_TIME"), en)
})

