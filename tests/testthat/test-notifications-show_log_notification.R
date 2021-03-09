testthat::context("notifications / show_log_notification")

testthat::test_that("function returns message and error outside of shiny app", {
  testthat::expect_message(
    testthat::expect_error(show_log_notification("xxx"), "-"),
    "xxx"
  )
})

testthat::skip_if_not_installed("shinytest")

testthat::test_that("function creates notification popup", {

  path <- "test-notifications-show_log_notification"
  app <- shinytest::ShinyDriver$new(path)
  testthat::expect_true(endsWith(app$getAppDir(), path))

  app$setInputs(button = "click", timeout_ = 60000)
  app$setInputs(button = "click", timeout_ = 60000)

  # find popup notofication by its XPath
  popup <- app$findElement(xpath = "//*[@id=\"shiny-notification-panel\"]")

  testthat::expect_equal(app$getAllValues()$export$count, 3)
  testthat::expect_equal(popup$getText(), "×\n1\n×\n2")

  app$stop()
})
