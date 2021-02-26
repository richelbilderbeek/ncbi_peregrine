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
  is_in_tmh_filenames <- list.files(
    path = "~/GitHubs/ncbi_peregrine/scripts",
    pattern = "_is_in_tmh\\.csv",
    full.names = TRUE
  )
  results_filename <- ncbiperegrine::create_results_file(
    is_in_tmh_filenames = is_in_tmh_filenames
  )
  t_results <- read_results_file(results_filename)
  n_variations <- nrow(t_results)
  t_snps <- dplyr::filter(t_results, !is.na(p_in_tmh))
  n_snps <- nrow(t_snps)
  expect_equal(n_snps, 38883)
  n_snps_map <- nrow(t_snps %>% dplyr::filter(p_in_tmh == 0.0))
  expect_equal(n_snps_map, 17144)
  n_snps_tmp <- nrow(t_snps %>% dplyr::filter(p_in_tmh > 0.0))
  expect_equal(n_snps_tmp, 8369 + 13369)

})
