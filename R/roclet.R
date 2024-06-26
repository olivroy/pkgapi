ns_tags <- c('api')

#' Roclet: make API file.
#'
#' This roclet automates the production of an `API` file that describes
#' the exported interface of a package.
#'
#' @export
#' @importFrom roxygen2 roclet
#' @api
api_roclet <- function() {
  roclet("api")
}

#' @importFrom roxygen2 roclet_process
#' @export
roclet_process.roclet_api <- function(x, ...) {
  invisible()
}

#' @importFrom roxygen2 roclet_tags
#' @export
roclet_tags.roclet_api <- function(x) {
  list(
    api = roxygen2::tag_toggle
  )
}

#' @importFrom roxygen2 roclet_output
#' @export
roclet_output.roclet_api <- function(x, results, base_path, ...) {
  output <- format(extract_api(base_path))

  file_name <- "API"
  API <- file.path(base_path, file_name)

  # FIXME: Add marker that indicates if this is "our" file
  # FIXME: write_if_different()
  cli::cli_inform(c(i = "Writing {.path API}"))
  writeLines(output, API)

  withr::with_dir(base_path, usethis::use_build_ignore(file_name))

  API
}

#' @importFrom roxygen2 roclet_clean
#' @export
roclet_clean.roclet_api <- function(x, base_path) {
  # FIXME: Check if this is "our" file
  API <- file.path(base_path, "API")
  unlink(API)
}
