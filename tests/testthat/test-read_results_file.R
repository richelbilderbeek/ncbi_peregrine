test_that("use", {
  results_filename <- system.file(
    "extdata",
    "results.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(results_filename))

  t_results <- read_results_file(results_filename)

  expect_true(tibble::is_tibble(t_results))
  expect_equal(
    names(t_results),
    c("gene_id", "gene_name", "snp_id", "variation", "is_in_tmh", "p_in_tmh")
  )
  expect_equal(nrow(t_results), 80)
})

test_that("remove duplicates", {
  results_filename <- system.file(
    "extdata",
    "results_with_duplicates.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(results_filename))
  t_results <- read_results_file(results_filename)

  expect_equal(nrow(dplyr::distinct(t_results)), 4)
  expect_equal(nrow(t_results), 4)
})
