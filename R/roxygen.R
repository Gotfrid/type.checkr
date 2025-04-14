#' @importFrom roxygen2 roxy_tag_warning
#' @exportS3Method roxygen2::roxy_tag_parse
roxy_tag_parse.roxy_tag_typeParam <- function(x) { # nolint
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

#' @importFrom roxygen2 tag_words_line
#' @exportS3Method roxygen2::roxy_tag_parse
roxy_tag_parse.roxy_tag_typecheck <- function(x) { # nolint
  roxygen2::tag_words_line(x)
}
