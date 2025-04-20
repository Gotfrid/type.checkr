#' Test file
tfile <- function(...) {
  system.file(
    "testcases", ...,
    package = "type.checkr"
  )
}
