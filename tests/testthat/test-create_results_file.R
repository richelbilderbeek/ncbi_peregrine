test_that("use", {
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = FALSE)

  source_filenames <- system.file(
    "extdata",
    c(
      "gene_names.csv",
      "1956_snps.csv", "7124_snps.csv", "348_snps.csv",
      "1956_variations.csv", "7124_variations.csv", "348_variations.csv",
      "1956_is_in_tmh.csv", "7124_is_in_tmh.csv", "348_is_in_tmh.csv"
    ),
    package = "ncbiperegrine"
  )
  filenames <- file.path(folder_name, basename(source_filenames))
  file.copy(
    from = source_filenames,
    to = filenames
  )
  expect_true(all(file.exists(filenames)))
  is_in_tmh_filenames <- list.files(
    path = folder_name, pattern = "_is_in_tmh\\.csv$", full.names = TRUE
  )

  results_filename <- create_results_file(
    is_in_tmh_filenames = is_in_tmh_filenames
  )
  expect_true(file.exists(results_filename))

  t_results <- read_results_file(results_filename)

  # All variations are unique
  expect_equal(length(t_results), length(unique(t_results)))
})

test_that("use", {
  skip("local only")
  results_filename <- "~/GitHubs/ncbi_peregrine/scripts/results.csv"
  t_results <- read_results_file(results_filename)
  expect_equal(nrow(t_results), nrow(dplyr::distinct(t_results)))
  n_variations <- length(t_results$variation)
  expect_equal(n_variations, 60931)
  n_unique_variations <- length(unique(t_results$variation))
  expect_equal(n_unique_variations, 60544)
  n_gene_ids <- length(unique(t_results$gene_id))
  expect_equal(n_gene_ids, 953)
  n_gene_names <- length(unique(t_results$gene_name))
  expect_equal(n_gene_names, 953)

  t_snps <- dplyr::filter(t_results, ncbi::are_snps(variation))
  expect_equal(nrow(t_snps), nrow(dplyr::distinct(t_snps)))

  n_unique_variations <- length(unique(t_snps$variation))
  expect_equal(37630, n_unique_variations)
  n_unique_snp_ids <- length(unique(t_snps$snp_id))
  expect_equal(9621, n_unique_snp_ids)

  t_snps_map <- dplyr::filter(t_snps, p_in_tmh == 0.0)
  expect_equal(nrow(t_snps_map), nrow(dplyr::distinct(t_snps_map)))
  n_snps_map <- nrow(t_snps_map)
  expect_equal(16623, n_snps_map)
  n_unique_snp_ids_map <- length(unique(t_snps_map$snp_id))
  expect_equal(9621, n_unique_snp_ids_map)

  t_snps_tmp <- dplyr::filter(t_snps, p_in_tmh > 0.0)
  n_snps_tmp <- nrow(t_snps_tmp)
  expect_equal(n_snps_tmp, 21208)

})
