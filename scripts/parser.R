library(roxygen2)

roxy_tag_parse.roxy_tag_type <- function(x) { # nolint
  typing <- unlist(strsplit(x$raw, " "))
  if (length(typing) != 2) {
    roxygen2::roxy_tag_warning("Incorrect param typing")
    return()
  }

  x$val <- list(
    name = typing[1],
    type = typing[2]
  )

  x
}

roxy_tag_parse.roxy_tag_typecheck <- function(x) { # nolint
  roxygen2::tag_words_line(x)
}

do_typecheck <- function(parsed_file) {
  defined_types <- list()
  check_passed <- TRUE

  for (block in parsed_file) {
    # Append type definitions
    if (!is.null(block$object) && class(block$object$value) == "function") {
      for (tag in block$tag) {
        if (tag$tag == "type") {
          if (is.null(defined_types[[block$object$alias]])) {
            defined_types[[block$object$alias]] <- list()
          }
          defined_types[[block$object$alias]][[tag$val$name]] <- parse(text = tag$val$type) # nolint
        }
      }
    }

    # Check argument types in a function call
    .tags <- unlist(block$tag)
    if (is.null(block$object) && length(.tags[.tags == "typecheck"]) > 0) {
      expr <- as.list(block$call)
      function_name <- as.character(expr[[1]])
      if (!function_name %in% names(defined_types)) {
        check_passed <- FALSE
        warning(
          "[", block$file, ":", block$line, "] ",
          "TypeError in `", as.expression(block$call), "`: ",
          "no type definitions found for function `", function_name, "`.",
          # "TypeError in ", function_name, " does not have type definitions",
          call. = FALSE
        )
        next
      }
      arguments <- expr[-1]
      for (arg in names(arguments)) {
        expected_type <- defined_types[[function_name]][[arg]]
        res <- try(
          vapply(arguments[[arg]], identity, eval(expected_type)),
          silent = TRUE
        )
        if (inherits(res, "try-error")) {
          check_passed <- FALSE
          warning(
            "[", block$file, ":", block$line, "] ",
            "TypeError in `", as.expression(block$call), "`: ",
            "`", arg, "` should be `", as.character(expected_type), "`, ",
            "not `", class(arguments[[arg]]), "`.",
            call. = FALSE
          )
        }
      }
    }
  }
  check_passed
}

parsed_file <- roxygen2::parse_file("scripts/example.R")
do_typecheck(parsed_file)
