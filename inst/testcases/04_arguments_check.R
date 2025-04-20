#' @param x Value
#' @typeParam x integer(1)
my_function <- function(x) {
  invisible(x)
}

#' Result: FAIL
#' Reason: Unnamed arguments
#' @typecheck
my_function("foo")
