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
  testthat::expect_equal(
    nrow(t_gene_names),
    nrow(dplyr::distinct(t_gene_names))
  )

  # Get all SNP IDs per gene name
  t_snp_ids <- ncbiperegrine::read_snps_files(
    snps_filenames = snp_ids_filenames
  )
  testthat::expect_equal(
    nrow(t_snp_ids),
    nrow(dplyr::distinct(t_snp_ids))
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

  # These are the gene IDs that were valid in 2020, and invalid in 2021
  removed_gene_ids <- unique(
    t_snp_ids$gene_id[
      which(!t_snp_ids$gene_id %in% t_gene_names$gene_id)
    ]
  )
  n_removed_gene_ids <- length(removed_gene_ids)
  testthat::expect_true(n_removed_gene_ids >= 0)


  # Inner join: keep the gene IDs that are in both tables
  t_results_1 <- dplyr::inner_join(
    t_gene_names,
    t_snp_ids,
    by = "gene_id"
  )
  testthat::expect_equal(
    nrow(t_results_1),
    nrow(dplyr::distinct(t_results_1))
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

  t_variations_all <- ncbiperegrine::read_variations_csv_files(
    variations_csv_filenames = variations_csv_filenames
  )
  testthat::expect_equal(
    nrow(t_variations_all),
    nrow(dplyr::distinct(t_variations_all))
  )

  # There is still the obsoleted gene ID in t_variations
  # These are the obsoleted SNPs
  obsolete_snp_ids <- unique(
    t_variations_all$snp_id[
      which(!t_variations_all$snp_id %in% t_results_1$snp_id)
    ]
  )
  testthat::expect_true(
    all(
      t_variations_all[
        t_variations_all$snp_id %in% obsolete_snp_ids,
      ]$gene_id == removed_gene_ids # Prove the link
    )
  )
  n_obsolete_snp_ids <- length(obsolete_snp_ids)
  testthat::expect_true(n_obsolete_snp_ids >= 0)


  snp_id <- NULL; rm(snp_id) # nolint, fixes warning: no visible binding for global variable
  # There is still the obsoleted gene ID in t_variations
  t_variations <- dplyr::filter(
    t_variations_all,
    snp_id %in% t_results_1$snp_id
  )
  testthat::expect_equal(
    nrow(t_variations),
    nrow(dplyr::distinct(t_variations))
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
  testthat::expect_equal(
    nrow(t_results_2),
    nrow(dplyr::distinct(t_results_2))
  )
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

  t_is_in_tmh_with_duplicates <- read_is_in_tmh_files(is_in_tmh_filenames)
  t_is_in_tmh <- dplyr::distinct(t_is_in_tmh_with_duplicates)
  testthat::expect_equal(
    nrow(t_is_in_tmh),
    nrow(dplyr::distinct(t_is_in_tmh))
  )

  # If is_in_tmh is TRUE or FALSE,
  # then the p_in_tmh must be in range [0,1]
  testthat::expect_equal(
    0,
    sum(!is.na(t_is_in_tmh$is_in_tmh) & is.na(t_is_in_tmh$p_in_tmh))
  )

  t_results_2$variation[!(t_results_2$variation %in% t_is_in_tmh$variation)]

  t_results_3 <- dplyr::full_join(
    x = t_results_2,
    y = t_is_in_tmh,
    by = "variation"
  )
  testthat::expect_equal(
    nrow(t_results_3),
    nrow(dplyr::distinct(t_results_3))
  )

  # If is_in_tmh is TRUE or FALSE,
  # then the p_in_tmh must be in range [0,1]
  # There is an error for e.g. variation NP_001170990.1:p.Gly254Arg
  testthat::expect_equal(
    0,
    sum(!is.na(t_results_3$is_in_tmh) & is.na(t_results_3$p_in_tmh))
  )

  # Read the topology for the number of TMHs
  topo_filenames <- stringr::str_replace(
    string = is_in_tmh_filenames,
    pattern = "_is_in_tmh.csv",
    replacement = ".topo"
  )
  testthat::expect_equal(0, sum(!file.exists(topo_filenames)))
  tibbles <- list()
  for (i in seq_along(topo_filenames)) {
    topo_filename <- topo_filenames[i]
    t <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)
    t$n_tmh <- pureseqtmr::count_n_tmhs(t$sequence)
    tibbles[[i]] <- dplyr::select(t, name, n_tmh)
  }
  t_topo <- dplyr::bind_rows(tibbles)

  t_results_3$name <- stringr::str_match(
    string = t_results$variation,
    pattern = "^(.*):p\\..*$"
  )[, 2]

  t_results_4 <- dplyr::left_join(
    t_results_3,
    dplyr::distinct(t_topo),
    by = "name"
  )
  testthat::expect_equal(
    0,
    nrow(
      dplyr::filter(
        dplyr::filter(t_results_4, p_in_tmh == 0.0),
        n_tmh != 0
      )
    )
  )

  readr::write_csv(x = t_results_4, file = results_filename)
  results_filename
}

