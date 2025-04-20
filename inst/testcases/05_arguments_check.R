#' @param x Value
#' @typeParam x integer(1)
my_function <- function(x) {
  invisible(x)
}

#' Result: FAIL
#' Reason: character does not match integer
#' @typecheck
my_function(x = "foo")
