#' @title Sort list of lists recursively
#' @description Sort list of lists recursively and alphabetically by names
#' @param lst list of lists
#' @return sorted list of lists
#' @author david.breuer
#' @export
#' @examples y <- list(b = 1, a = "c", c = 1)
#' x <- list(2, 3, 1)
#' lst <- list(y = y, x = x, z = 1)
#' sort_recursive(lst)
sort_recursive <- function(lst) {
  # stop if not a list and return original
  if (!is.list(lst)) return(lst)
  # get key names otherwise
  nms <- names(lst)
  # sort parent list by key name
  if (!is.null(nms)) lst <- lst[order(nms)]
  # loop over children lists
  lapply(lst, sort_recursive)
}
