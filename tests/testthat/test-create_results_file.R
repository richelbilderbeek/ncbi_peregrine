test_that("use", {
  is_in_tmh_filenames <- system.file(
    "extdata",
    c("1956_is_in_tmh.csv", "7124_is_in_tmh.csv", "348_is_in_tmh.csv"),
    package = "ncbiperegrine"
  )

  expect_true(all(file.exists(is_in_tmh_filenames)))

  results_filename <- create_results_file(
    is_in_tmh_filenames = is_in_tmh_filenames
  )
  expect_true(file.exists(results_filename))

  t_results <- read_results_file(results_filename)

  # All variations are unique
  expect_equal(length(t_results), length(unique(t_results)))
})
