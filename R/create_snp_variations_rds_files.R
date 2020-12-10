#' For each gene's SNPs,
#' create an \code{rds} file containing a tibble of variations per SNP
#' @inheritParams default_params_doc
#' @return names of the \code{rds} files created
#' @export
create_snp_variations_rds_files <- function( # nolint indeed a long function name
  snps_filenames,
  n_snps,
  verbose = FALSE
) {
  testthat::expect_true(length(snps_filenames) > 0)
  testthat::expect_true(all(file.exists(snps_filenames)))
  testthat::expect_true(n_snps > 0)

  n_snps_filenames <- length(snps_filenames)
  variations_rds_filenames <- rep(NA, n_snps_filenames)
  for (i in seq_len(n_snps_filenames)) {
    if (verbose) message(i, "/", n_snps_filenames, ": ", snps_filenames[i])
    variations_rds_filenames[i] <-
      ncbiperegrine::create_snp_variations_rds_file(
        snps_filename = snps_filenames[i],
        n_snps = n_snps,
        verbose = verbose
      )
  }
  variations_rds_filenames
}
