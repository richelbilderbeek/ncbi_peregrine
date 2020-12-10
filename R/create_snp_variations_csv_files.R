#' For each \code{rds} file
#' (each containing a list of tibbles with SNP ID and variations),
#' convert it to a \code{csv} file with the merged table
#' @inheritParams default_params_doc
#' @return names of the \code{csv} files created
#' @export
create_snp_variations_csv_files <- function( # nolint indeed a long function name
  variations_rds_filenames,
  verbose = FALSE
) {
  testthat::expect_true(all(file.exists(variations_rds_filenames)))
  n_variations_rds_filenames <- length(variations_rds_filenames)
  variations_csv_filenames <- rep(NA, n_variations_rds_filenames)

  for (i in seq_len(n_variations_rds_filenames)) {
    if (verbose) {
      message(
        i, "/", n_variations_rds_filenames, ": ", variations_rds_filenames[i]
      )
    }
    variations_csv_filenames[i] <-
      ncbiperegrine::create_snp_variations_csv_file(
        variations_rds_filename = variations_rds_filenames[i]
      )
  }
  variations_csv_filenames
}
