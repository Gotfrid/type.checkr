#' @param x Value
#' @typeParam x integer(1)
my_function <- function(x) {
  invisible(x)
}

#' Result: PASS
#' Reason: 1L is integer(1)
#' @typecheck
my_function(x = 1L)
