#' Read a \code{[gene_name]_variations.csv} file
#' @inheritParams default_params_doc
#' @return a \link[tibble]{tibble} with columns \code{snp_id}
#' and \code{variation}
#' @export
read_variations_csv_file <- function(variations_csv_filename) {
  testthat::expect_true(file.exists(variations_csv_filename))
  testthat::expect_silent({
    t_variations <- readr::read_csv(
      file = variations_csv_filename,
      col_types = readr::cols(
        snp_id = readr::col_double(),
        variation = readr::col_character()
      )
    )
  })
  t_variations
}
