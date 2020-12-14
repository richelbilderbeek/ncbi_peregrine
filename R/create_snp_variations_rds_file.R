#' For each gene's SNPs,
#' create an \code{rds} file containing a tibble of variations per SNP
#' @inheritParams default_params_doc
#' @return names of the \code{rds} files created
#' @export
create_snp_variations_rds_file <- function(
  snps_filename,
  n_snps,
  verbose = FALSE
) {
  testthat::expect_equal(1, length(snps_filename))
  testthat::expect_true(file.exists(snps_filename))
  variations_rds_filename <- stringr::str_replace(
    string = snps_filename,
    pattern = "_snps.csv",
    replacement = "_variations.rds"
  )

  # Create all RDS files with an empty list
  if (!file.exists(variations_rds_filename)) {
    saveRDS(object = list(), file = variations_rds_filename)
  }

  # The SNPs working on that gene that we already know
  t_snp_ids <- ncbiperegrine::read_snps_file(snps_filename)

  # The variations we're about to obtain
  testthat::expect_true(file.exists(variations_rds_filename))
  # List of tibbles with snp_id and variation
  tibbles <- readRDS(variations_rds_filename)

  # Per i'th gene name, read its j'th SNPs and save the variations
  for (j in seq(1, n_snps)) {
    if (verbose) message(j, "/", n_snps, ": ", snps_filename)

    if (length(tibbles) == n_snps &&
        tibble::is_tibble(utils::tail(tibbles, n = 1))) {
      # TODO: output DONE
      next
    }

    # Per SNP, obtain the variation
    # Save to file after each SNP
    if (j <= length(tibbles)) {
      testthat::expect_true(tibble::is_tibble(tibbles[[j]]))
      if (verbose) {
        message("SNP ", j, "/", n_snps, ": already done")
      }
      next
    }

    if (nrow(t_snp_ids) != 0) {
      # There are SNP IDs
      snp_id <- t_snp_ids$snp_id[j]
      variations <- ncbi::get_snp_variations_in_protein_from_snp_id(snp_id)
      tibbles[[j]] <- tibble::tibble(
        snp_id = snp_id,
        variation = variations,
      )
    } else {
      # Protein has no SNP IDs
      tibbles[[j]] <- tibble::tibble(
        snp_id = numeric(0),
        variation = character(0),
      )
    }

    saveRDS(object = tibbles, file = variations_rds_filename)
  }
  variations_rds_filename
}
