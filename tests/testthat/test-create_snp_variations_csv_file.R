test_that("use", {
  variations_rds_filename <- system.file(
    "extdata",
    "1956_variations.rds",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(variations_rds_filename))
  variations_csv_filename <- create_snp_variations_csv_file(
    variations_rds_filename = variations_rds_filename
  )
  expect_true(file.exists(variations_csv_filename))
  tibbles <- readRDS(variations_rds_filename)
  t_variations <- readr::read_csv(variations_csv_filename)

  # The four variations can be found in both the list
  # and the created tibble
  expect_equal(tibbles[[23]], t_variations[1:2, ])
  expect_equal(tibbles[[24]], t_variations[3:4, ])
})
