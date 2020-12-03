#' Read a \code{[gene_name]_snps.csv} file
#' @inheritParams default_params_doc
#' @return a \link[tibble]{tibble} with one column named \code{snp_id}
#' @export
read_snps_file <- function(snps_filename) {
  testthat::expect_true(file.exists(snps_filename))
  readr::read_csv(
    snps_filename,
    col_types = readr::cols(
      snp_id = readr::col_double()
    )
  )
}
