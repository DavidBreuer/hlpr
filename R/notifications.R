#' @title Logs a message and shows shiny notification
#' @param msg error/warning/info message
#' @param type type of message
#' @param quiet turn off Shiny notification
#' @param ... further parameters that will be passed to
#' \code{\link[shiny]{showNotification}}
#' @return notification
#' @export
#' @author david.breuer
#' @family notification
#' @seealso \code{\link[shiny]{showNotification}}
#' @examples if (interactive()){
#' library(shiny)
#' shinyApp(
#'   ui <- fluidPage(
#'     actionButton("button", "Click!")
#'   ),
#'   server <- function(input, output) {
#'     count <<- 0
#'     observeEvent(input$button, {
#'       show_log_notification(count)
#'       count <<- count + 1
#'     })
#'   }
#' )}
show_log_notification <- function(msg, type = "default", quiet = FALSE, ...) {
  log_msg <- paste0(Sys.time(), ": ", gsub("<.*?>", "", msg))
  message(log_msg)
  if (!quiet) {
    shiny::showNotification(shiny::HTML(msg), type = type, ...)
  }
}
