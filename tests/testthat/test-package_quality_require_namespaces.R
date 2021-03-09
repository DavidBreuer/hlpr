testthat::context("package_quality / require_namespaces")

testthat::test_that("returns no error for known packages (with versions)", {
  testthat::expect_true(
    testthat::expect_error(
      require_namespaces(c("base", "stats")), NA
    )
  )
  testthat::expect_error(
    require_namespaces(c("base", "stats"), versions = c("3.0.0", NA)), NA
  )
})

testthat::test_that("returns errors for unknown packages (with versions)", {
  testthat::expect_false(
    testthat::expect_warning(
      require_namespaces(c("baseXY", "statsXY"), error = FALSE)
    )
  )
  testthat::expect_error(
    require_namespaces(c("baseXY", "statsXY"))
  )
  testthat::expect_error(
    require_namespaces(c("baseXY", "statsXY"), versions = c("3.0.0", NA))
  )
})

testthat::test_that("returns errors for failed version requirements", {
  version <- "99.9.9"
  testthat::expect_error(
    require_namespaces(c("base", "stats"), versions = c(version, NA)), version
  )
  testthat::expect_error(
    require_namespaces(c("base", "stats"), versions = c(version)), "per package"
  )
})

