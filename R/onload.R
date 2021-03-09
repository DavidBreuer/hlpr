#' @title Set locale to EN upon package loading
#' @description Set locale to EN upon package loading,
#' see https://stackoverflow.com/a/20223846/5350621
#' @param libname libname
#' @param pkgname pkgname
#' @return Nothing
#' @export
#' @author david.breuer
.onLoad <- function(libname, pkgname){
  Sys.setlocale("LC_ALL", "en_US.UTF-8")
}
