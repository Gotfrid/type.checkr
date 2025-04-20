#' @param x Value
#' @typeParam x integer(1)
my_function <- function(x) {
  invisible(x)
}

#' @typecheck
my_function("foo")
