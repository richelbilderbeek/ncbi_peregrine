#' Create the results file
#' @inheritParams default_params_doc
#' @export
create_results_file <- function(
  is_in_tmh_filenames
) {
  # Filenames
  # All folder names must be the same
  testthat::expect_equal(length(unique(dirname(is_in_tmh_filenames))), 1)
  gene_names_filename <- file.path(
    dirname(is_in_tmh_filenames)[1], "gene_names.csv"
  )
  testthat::expect_equal(length(gene_names_filename), 1)
  testthat::expect_true(file.exists(gene_names_filename))

  snp_ids_filenames <- stringr::str_replace(
    string = is_in_tmh_filenames,
    pattern = "_is_in_tmh.csv",
    replacement = "_snps.csv"
  )
  testthat::expect_true(all(file.exists(snp_ids_filenames)))

  variations_csv_filenames <- stringr::str_replace(
    string = is_in_tmh_filenames,
    pattern = "_is_in_tmh.csv",
    replacement = "_variations.csv"
  )
  testthat::expect_true(all(file.exists(variations_csv_filenames)))

  results_filename <- file.path(
    dirname(is_in_tmh_filenames)[1], "results.csv"
  )
  testthat::expect_equal(length(results_filename), 1)

  #
  # Create t_results for the first three columns
  #
  #        t_results_1
  # |---------------------------|
  #
  # gene_id|gene_name|snp_id    |variation              |is_in_tmh|p_in_tmh     # nolint this is no code
  # -------|---------|----------|-----------------------|---------|--------
  # 7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.123        # nolint this is no code
  # ...    |...      |...       |...                    |...      |...          # nolint this is no code
  #
  # |----------------|
  #   t_gene_names
  #
  #                  |----------|
  #                  [gene_name]_snps.csv
  #

  # Gene name to gene ID LUT
  t_gene_names <- ncbiperegrine::read_gene_names_file(gene_names_filename)

  # Get all SNP IDs per gene name
  t_snp_ids <- ncbiperegrine::read_snps_files(
    snps_filenames = snp_ids_filenames
  )
  # All SNP IDs are unique
  testthat::expect_equal(
    length(t_snp_ids$snp_id),
    length(unique(t_snp_ids$snp_id))
  )

  t_results_1 <- dplyr::inner_join(
    t_gene_names,
    t_snp_ids,
    by = "gene_id"
  )

  testthat::expect_equal(nrow(t_results_1), nrow(t_snp_ids))

  # All SNP IDs are unique
  testthat::expect_equal(
    length(t_results_1$snp_id),
    length(unique(t_results_1$snp_id))
  )

  t_results_1
  #
  # Create t_results for the first four columns
  #
  #         t_results_1
  # |---------------------------|
  #
  #                     t_results_2
  # |---------------------------------------------------|
  #
  # gene_id|gene_name|snp_id    |variation              |is_in_tmh|p_in_tmh     # nolint this is no code
  # -------|---------|----------|-----------------------|---------|--------
  # 7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.123        # nolint this is no code
  # ...    |...      |...       |...                    |...      |...          # nolint this is no code
  #
  # |----------------|
  #   gene_names.csv
  #
  #                  |----------|
  #                  [gene_name]_snps.csv
  #
  #                  |----------------------------------|
  #                       [gene_name]_variations.csv
  #
  t_results_1

  t_variations <- ncbiperegrine::read_variations_csv_files(
    variations_csv_filenames = variations_csv_filenames
  )
  testthat::expect_true(all(t_variations$snp_id %in% t_results_1$snp_id))
  # A SNP IDs can have multiple variations ...
  testthat::expect_false(
    length(t_variations$snp_id) ==
    length(unique(t_variations$snp_id))
  )
  # ... but all variations are unique
  testthat::expect_equal(
    length(t_variations$variation),
    length(unique(t_variations$variation))
  )


  t_results_2 <- dplyr::inner_join(
    x = t_results_1,
    y = t_variations,
    by = c("gene_id", "snp_id")
  )
  testthat::expect_equal(nrow(t_results_2), nrow(t_variations))
  t_results_2

  # A SNP IDs can have multiple variations ...
  testthat::expect_false(
    length(t_results_2$snp_id) == length(unique(t_results_2$snp_id))
  )
  # ... but all variations are unique
  testthat::expect_equal(
    length(t_results_2$variation),
    length(unique(t_results_2$variation))
  )

  # Create t_results for all columns
  #
  #                     t_results_2
  # |---------------------------------------------------|
  #
  #                     t_results
  # |---------------------------------------------------------------------|
  #
  # gene_id|gene_name|snp_id    |variation              |is_in_tmh|p_in_tmh     # nolint this is no code
  # -------|---------|----------|-----------------------|---------|--------
  # 7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.123        # nolint this is no code
  # ...    |...      |...       |...                    |...      |...          # nolint this is no code
  #
  # |----------------|
  #   gene_names.csv
  #
  #                  |----------|
  #                  [gene_name]_snps.csv
  #
  #                  |----------------------------------|
  #                       [gene_name]_variations.csv
  #
  #                             |------------------------------------------|
  #                                      [gene_name]_is_in_tmh.csv

  t_is_in_tmh <- read_is_in_tmh_files(is_in_tmh_filenames)

  t_results <- dplyr::inner_join(
    x = t_results_2,
    y = t_is_in_tmh,
    by = "variation"
  )
  testthat::expect_equal(nrow(t_results_2), nrow(t_is_in_tmh))

  readr::write_csv(x = t_results, file = results_filename)
  results_filename
}
