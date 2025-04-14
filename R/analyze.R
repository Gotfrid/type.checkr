#' Analyze
#' Perform the type checks for a given file
#' @param filepath Path to the analyzed file
#' @return Boolean whether the check passes
#' @importFrom roxygen2 parse_file
#' @export
analyze <- function(filepath) {
  parsed_file <- roxygen2::parse_file(filepath)
  check_result <- TRUE

  type_definitions <- lapply(parsed_file, function(block) {
    # Handle function roclet
    if (inherits(block$object, "function")) {
      params <- Filter(function(x) x$tag == "param", block$tags)
      types <- Filter(function(x) x$tag == "typeParam", block$tags)

      param_names <- sapply(params, \(x) x$val$name)
      type_names <- sapply(types, \(x) x$val$name)


      # Assert: every param has a type
      params_without_type <- setdiff(param_names, type_names)
      if (length(params_without_type) > 0) {
        warning("TypeError")
        check_result <<- FALSE
      }

      # Assert: every type has a param
      types_without_param <- setdiff(type_names, param_names)
      if (length(types_without_param) > 0) {
        warning("TypeError")
        check_result <<- FALSE
      }
    }
  })

  check_result
}
