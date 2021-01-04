#' Read a \code{[gene_id]_variations.rds} file
#' @inheritParams default_params_doc
#' @return a list of tibbles
#' @export
read_variations_rds_file <- function(variations_rds_filename) {
  tibbles <- readRDS(variations_rds_filename)
  testthat::expect_true(is.list(tibbles))
  testthat::expect_true(
    all(purrr:::map_lgl(tibbles, tibble::is_tibble))
  )
  tibbles
}
