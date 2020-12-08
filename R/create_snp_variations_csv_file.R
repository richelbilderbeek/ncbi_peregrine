#' For each \code{rds} file
#' (each containing a list of tibbles with SNP ID and variations),
#' convert it to a \code{csv} file with the merged table
#' @inheritParams default_params_doc
#' @return names of the \code{csv} files created
#' @export
create_snp_variations_csv_file <- function(
  variations_rds_filename
) {
  testthat::expect_true(length(variations_rds_filename) == 1)
  testthat::expect_true(file.exists(variations_rds_filename))

  variations_csv_filename <- stringr::str_replace(
    string = variations_rds_filename,
    pattern = "_variations.rds",
    replacement = "_variations.csv"
  )

  readr::write_csv(
    x = dplyr::bind_rows(readRDS(variations_rds_filename)),
    file = variations_csv_filename
  )
  variations_csv_filename
}
