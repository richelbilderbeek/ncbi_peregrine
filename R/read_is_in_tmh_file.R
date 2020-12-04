#' Read a \code{[gene_name]_is_in_tmh.csv} file
#' @inheritParams default_params_doc
#' @return a \link[tibble]{tibble} with columns named
#' \code{variation}, \code{is_in_tmh} and \code{p_in_tmh}
#' @export
read_is_in_tmh_file <- function(is_in_tmh_filename) {
  testthat::expect_true(file.exists(is_in_tmh_filename))
  readr::read_csv(
    is_in_tmh_filename,
    col_types = readr::cols(
      variation = readr::col_character(),
      is_in_tmh = readr::col_logical(),
      p_in_tmh = readr::col_double()
    )
  )
}
