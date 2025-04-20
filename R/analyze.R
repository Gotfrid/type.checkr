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
    # Handle function definition
    if (inherits(block$object, "function")) {
      params <- Filter(function(x) x$tag == "param", block$tags)
      types <- Filter(function(x) x$tag == "typeParam", block$tags)
      typeReturn <- Filter(function(x) x$tag == "typeReturn", block$tags) # nolint

      param_names <- sapply(params, \(x) x$val$name)
      type_names <- sapply(types, \(x) x$val$name)
      return_type <- sapply(typeReturn, \(x) x$val)

      if (length(return_type) == 0) {
        # TODO: this should throw a warning and fail type check
        return_type <- "character()"
      }

      if (length(return_type) > 1) {
        warning("TypeError: Multiple return types specified")
        check_result <- FALSE
        return_type <- return_type[[1]]
      }

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

      type_definitions[[function_name]] <- unlist(type_params, recursive = FALSE) # nolint
      type_definitions[[function_name]]$..typeReturn <- return_type
    }

    # Handle variable assignment
    if (inherits(block$object, "data")) {
      expr <- as.list(block$call)

      object_name <- as.character(expr[[2]])
      function_name <- as.character(expr[[3]][[1]])

      type_definitions[[object_name]] <- type_definitions[[function_name]]$..typeReturn # nolint
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

      if (class(arguments[[arg]]) == "name") {
        variable_name <- as.character(arguments[[arg]])
        actual_type <- type_definitions[[variable_name]]

        if (is.null(actual_type)) {
          warning("TypeError: Variable type undefined")
          check_result <<- FALSE
        }

        if (actual_type != expected_type) {
          warning("TypeError: Variable type mismatch")
          check_result <<- FALSE
        }
      } else {
        res <- try(
          vapply(arguments[[arg]], identity, eval(parse(text = expected_type))),
          silent = TRUE
        )
        if (inherits(res, "try-error")) {
          warning("TypeError: Argument type mismatch")
          check_result <<- FALSE
        }
      }

    }
  })

  check_result
}
