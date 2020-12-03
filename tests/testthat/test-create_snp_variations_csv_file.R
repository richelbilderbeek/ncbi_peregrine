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
  file.remove(variations_csv_filename)
  expect_true(!file.exists(variations_csv_filename))
})
