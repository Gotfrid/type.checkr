#' @param a First value
#' @param b Second value
#' @typeParam a numeric(1)
#' @typeParam b numeric(1)
my_function <- function(a, b) {
  invisible()
}

#' @typecheck
rnorm(n = 1, mean = 0, sd = 1)

#' @typecheck
my_function(a = "hello", b = "world")

#' @typecheck
my_function(a = 3, b = 4)
