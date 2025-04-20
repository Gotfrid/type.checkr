#' @param x Value
#' @typeParam x integer(1)
#' @typeReturn integer(1)
my_function <- function(x) {
  invisible(x)
}

#' @typecheck
res <- my_function(x = 1L)

#' Result: PASS
#' Reason: res is defined earlier, and typed with my_function's typeReturn
#' @typecheck
my_function(x = res)
