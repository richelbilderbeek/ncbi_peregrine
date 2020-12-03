#' Check if all the SNP IDs in the list are in the tibble of SNP IDs
#' @param tibbles List of tibbles with snp_id and variation
#' @param t_snp_ids tibble with only the column \code{snp_id}
check_list_has_valid_snp_ids <- function(
  tibbles,
  t_snp_ids
) {
  t_tibbles <- dplyr::bind_rows(tibbles)
  testthat::expect_true(all(t_tibbles$snp_id %in% t_snp_ids$snp_id))
}

#' For each gene,
#' create an \code{rds} file containing a tibble of variations per SNP
#' @inheritParams default_params_doc
#' @return names of the \code{rds} files created
create_snp_variations_rds <- function(gene_names_filename) {

  testthat::expect_true(file.exists(gene_names_filename))
  t <- readr::read_csv(
    file = gene_names_filename,
    col_types = readr::cols(
      gene_id = readr::col_double(),
      gene_name = readr::col_character()
    )
  )
  testthat::expect_true("gene_id" %in% names(t))
  testthat::expect_true("gene_name" %in% names(t))
  t$variations_rds_filename <- paste0(t$gene_id, "_variations.rds")
  t$snps_filename <- paste0(t$gene_id, "_snps.csv")

  # Create all files with an empty list
  for (i in seq_len(nrow(t))) {
    variations_rds_filename <- t$variations_rds_filename[i] # To save the variations to
    if (!file.exists(variations_rds_filename)) {
      saveRDS(object = list(), file = variations_rds_filename)
    }
  }

  # Per i'th gene name, read its j'th SNPs and save the variations

  j <- 1
  for (j in seq(1, 10)) {
    for (i in seq_len(nrow(t))) {

      # The gene
      gene_name <- t$gene_name[i]
      message(i, "/", nrow(t), ": ", gene_name, " for the ", j, "th SNP")

      # The SNPs working on that gene that we already know
      snps_filename <- t$snps_filename[i]
      testthat::expect_true(file.exists(snps_filename))
      t_snp_ids <- readr::read_csv(
        snps_filename,
        col_types = readr::cols(
          snp_id = readr::col_double()
        )
      )

      # The variations we're about to obtain
      variations_rds_filename <- t$variations_rds_filename[i] # To save the variations to, may be half done
      testthat::expect_true(file.exists(variations_rds_filename))
      # List of tibbles with snp_id and variation
      tibbles <- readRDS(variations_rds_filename)

      if (length(tibbles) == nrow(t_snp_ids) &&
          tibble::is_tibble(utils::tail(tibbles, n = 1))) {
        # All SNP IDs in the list of tibbles with snp_id and variation
        # must be in the tibble with SNP IDs
        check_list_has_valid_snp_ids(tibbles = tibbles, t_snp_ids = t_snp_ids)
        next
      }


      # Per SNP, obtain the variation
      # Save to file after each SNP
      if (j <= length(tibbles)) {
        testthat::expect_true(tibble::is_tibble(tibbles[[j]]))
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
  }
  t$variations_rds_filename
}
