# duration = NULL so the popup notifications do not disappear and can be tested
shinyServer(
  function(input, output, session) {
    count <<- 1
    observeEvent(input$button, {
      hlpr::show_log_notification(count, duration = 2)
      count <<- count + 1
    })
    exportTestValues(count = {count})
  }
)
