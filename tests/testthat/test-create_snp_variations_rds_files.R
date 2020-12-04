test_that("use", {
  snps_filenames <- system.file(
    "extdata", c("1956_snps.csv", "348_snps.csv", "7124_snps.csv"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(snps_filenames)))
  variations_rds_filenames <- create_snp_variations_rds_files(
    snps_filenames = snps_filenames,
    n_snps = 2
  )
  expect_true(all(file.exists(variations_rds_filenames)))
})
