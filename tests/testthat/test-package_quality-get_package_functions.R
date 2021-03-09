testthat::context("package_quality / get_package_functions")

testthat::test_that("list of functions in this test file", {
  name <- "test-package_quality-get_package_functions.R"
  full <- get_package_functions(name, expand = TRUE)$packages
  pkgs <- c("hlpr", "testthat")
  sdiff <- setdiff(full, pkgs)
  testthat::expect_true(length(sdiff) == 0, info = sdiff)
})

testthat::test_that("all used packages are listed in DESCRIPTION", {
  full <- get_package_functions("../../R")$package
  pkgs <- get_package_description("hlpr")
  pkgs <- unname(unlist(pkgs))
  sdiff <- setdiff(full, pkgs)
  testthat::expect_true(length(sdiff) == 0, info = sdiff)
})
