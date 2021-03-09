testthat::context("package_quality / get_package_description")

testthat::test_that("testthat is contained in DESCRIPTION file", {
  pkgs <- get_package_description("hlpr")
  pkgs <- unname(unlist(pkgs))
  testthat::expect_true(is.element("testthat", pkgs))
})
