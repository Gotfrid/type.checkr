#' Analyze
#' Perform the type checks for a given file
#' @param filepath Path to the analyzed file
#' @return Boolean whether the check passes
#' @importFrom roxygen2 parse_file
#' @export
analyze <- function(filepath) {
  parsed_file <- roxygen2::parse_file(filepath)
  check_result <- TRUE

  type_definitions <- new.env()

  for (block in parsed_file) {
    # Handle function roclet
    if (inherits(block$object, "function")) {
      params <- Filter(function(x) x$tag == "param", block$tags)
      types <- Filter(function(x) x$tag == "typeParam", block$tags)

      param_names <- sapply(params, \(x) x$val$name)
      type_names <- sapply(types, \(x) x$val$name)

      # Assert: every param has a type
      params_without_type <- setdiff(param_names, type_names)
      if (length(params_without_type) > 0) {
        warning("TypeError: Params without types")
        check_result <- FALSE
      }

      # Assert: every type has a param
      types_without_param <- setdiff(type_names, param_names)
      if (length(types_without_param) > 0) {
        warning("TypeError: Types for undefined params")
        check_result <- FALSE
      }

      # Add types to the definition
      function_name <- block$object$alias
      params_with_types <- intersect(param_names, type_names)
      type_params <- lapply(types, function(tag) {
        if (tag$val$name %in% params_with_types) {
          setNames(list(x = tag$val$type), tag$val$name)
        }
      })

      type_definitions[[function_name]] <- list(
        x = unlist(type_params, recursive = FALSE)
      )
    }
  }

  lapply(parsed_file, function(block) {
    tags <- vapply(block$tag, \(x) x$tag, character(1))

    # Only process @typecheck
    if (!"typecheck" %in% tags) {
      return(NULL)
    }

    # Only process function calls
    # TODO: more robust check?
    if (!is.null(block$object)) {
      return(NULL)
    }

    expr <- as.list(block$call)
    function_name <- as.character(expr[[1]])

    if (!function_name %in% names(type_definitions)) {
      warning("TypeError: Function type undefined")
      check_result <<- FALSE
    }

    arguments <- expr[-1]
    if (length(arguments) != length(names(arguments))) {
      warning("TypeError: Unnamed function arguments")
      check_result <<- FALSE
    }

    for (arg in names(arguments)) {
      expected_type <- type_definitions[[function_name]][[arg]]
      res <- try(
        vapply(arguments[[arg]], identity, eval(parse(text = expected_type))),
        silent = TRUE
      )
      if (inherits(res, "try-error")) {
        warning("TypeError: Argument type mismatch")
        check_result <<- FALSE
      }
    }
  })

  check_result
}
