test_that("use", {
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = FALSE)

  source_filenames <- system.file(
    "extdata",
    c(
      "gene_names.csv",
      "1956.topo", "7124.topo", "348.topo",
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
  skip("Local only")

  is_in_tmh_filenames <- list.files(
    path = "~/GitHubs/ncbi_peregrine/scripts",
    pattern = "_is_in_tmh\\.csv$",
    full.names = TRUE
  )
  expect_equal(length(is_in_tmh_filenames), 1131)

  results_filename <- create_results_file(
    is_in_tmh_filenames = is_in_tmh_filenames
  )
  expect_true(file.exists(results_filename))

  t_results <- read_results_file(results_filename)

  # All variations are unique
  expect_equal(nrow(t_results), nrow(dplyr::distinct(t_results)))
  expect_equal(nrow(t_results), 60931)
})
