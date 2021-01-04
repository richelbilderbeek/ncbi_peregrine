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
  # Not all SNP IDs are unique, for example
  # Gene ID | Gene name | SNP ID
  # --------|-----------|------------|--------------------
  # 113179  | ADAT3     | 1599245193 | adenosine deaminase
  # 113178  | SCAMP4    | 1599245193 | secretory carrier membrane protein 4
  if (1 == 2) {
    t_snp_ids[utils::head(which(duplicated(t_snp_ids$snp_id))), ]
    t_snp_ids[which(t_snp_ids$snp_id == 1599245193), ]
    t_gene_names[
      which(t_gene_names$gene_id == 113178 | t_gene_names$gene_id == 113179),
    ]
  }

  t_results_1 <- dplyr::inner_join(
    t_gene_names,
    t_snp_ids,
    by = "gene_id"
  )

  testthat::expect_equal(nrow(t_results_1), nrow(t_snp_ids))
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
  # ... but also not all variations are unique
  #
  # Gene ID | Gene name | SNP ID     | Variation
  # --------|-----------|------------|------------------------
  # 406991  | MIR21     | 1598476080 | NP_112200.2:p.Glu369Gly                  # nolint this is no commented code
  # 81671   | VMP1      | 1598476080 | NP_112200.2:p.Glu369Gly                  # nolint this is no commented code
  if (1 == 2) {
    t_variations[utils::head(which(duplicated(t_variations$variation))), ]
    t_variations[
      which(t_variations$variation == "NP_001316323.1:p.Glu369Gly"),
    ]
    t_gene_names[
      which(t_gene_names$gene_id == 406991 | t_gene_names$gene_id == 81671),
    ]
  }

  t_results_2 <- dplyr::inner_join(
    x = t_results_1,
    y = t_variations,
    by = c("gene_id", "snp_id")
  )
  testthat::expect_equal(nrow(t_results_2), nrow(t_variations))
  t_results_2

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

  # If is_in_tmh is TRUE or FALSE,
  # then the p_in_tmh must be in range [0,1]
  testthat::expect_equal(
    0,
    sum(!is.na(t_is_in_tmh$is_in_tmh) & is.na(t_is_in_tmh$p_in_tmh))
  )

  t_results_2$variation[!(t_results_2$variation %in% t_is_in_tmh$variation)]

  t_results <- dplyr::full_join(
    x = t_results_2,
    y = t_is_in_tmh,
    by = "variation"
  )
  testthat::expect_equal(nrow(t_results_2), nrow(t_is_in_tmh))

  # If is_in_tmh is TRUE or FALSE,
  # then the p_in_tmh must be in range [0,1]
  # There is an error for e.g. variation NP_001170990.1:p.Gly254Arg
  testthat::expect_equal(
    0,
    sum(!is.na(t_results$is_in_tmh) & is.na(t_results$p_in_tmh))
  )

  readr::write_csv(x = t_results, file = results_filename)
  results_filename
}
