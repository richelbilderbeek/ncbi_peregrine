test_that("use", {
  variations_rds_filenames <- system.file(
    "extdata",
    c("1956_variations.rds", "348_variations.rds", "7124_variations.rds"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(variations_rds_filenames)))
  variations_csv_filenames <- create_snp_variations_csv_files(
    variations_rds_filenames = variations_rds_filenames
  )
  expect_true(all(file.exists(variations_csv_filenames)))
  file.remove(variations_csv_filenames)
  expect_true(all(!file.exists(variations_csv_filenames)))
})
