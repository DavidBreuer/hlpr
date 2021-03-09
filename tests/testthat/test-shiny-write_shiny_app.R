testthat::context("shiny / write_shiny_app")

testthat::skip_if_not_installed("shinytest")

library(shiny)
library(shinytest)

ui <- "shinyUI(
  fluidPage(
    actionButton(\"button\", \"Click!\")
  )
)"

server <- "shinyServer(
  function(input, output, session) {
    count <<- 1
    observeEvent(input$button, {
      count <<- count + 1
    })
  exportTestValues(count = {count})
  }
)"

testthat::test_that(
  "app starts without errors", {
    tmp <- tempdir()
    write_shiny_app(tmp, ui, server)
    app <- shinytest::ShinyDriver$new(tmp)
    logs <- app$getDebugLog()
    errs <- grepl("Error", logs)
    testthat::expect_false(any(errs))
    app$stop()
})

