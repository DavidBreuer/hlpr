#' @title Write a Shiny app to a temporary directory for shinytesting
#' @param tmp  Temporary directory
#' @param ui Shiny ui file as string
#' @param server Shiny server file as string
#' @return Two files, ui.R and server.R, in temporary directory
#' @author david.breuer
#' @export
write_shiny_app <- function(tmp, ui, server) {
  con <- file(file.path(tmp, "ui.R"))
  writeLines(ui, con)
  close(con)
  con <- file(file.path(tmp, "server.R"))
  writeLines(server, con)
  close(con)
}

