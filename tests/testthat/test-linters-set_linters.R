testthat::context("linters / daqana_linters")
testthat::skip_if_not_installed("lintr")

testthat::test_that("set_linters should include only functions", {
  testthat::expect_true(all(lapply(set_linters(), is.function) == TRUE))
})
