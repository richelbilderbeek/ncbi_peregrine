test_that("use", {
  snps_filename <- system.file(
    "extdata", "7124_snps.csv",
    package = "ncbiperegrine"
  )
  n_snps <- 10
  expect_true(file.exists(snps_filename))
  readLines(snps_filename)
  variations_rds_filename <- create_snp_variations_rds_file(
    snps_filename = snps_filename,
    n_snps = n_snps
  )
  expect_true(file.exists(variations_rds_filename))
  tibbles <- readRDS(variations_rds_filename)

  expect_equal(length(tibbles), n_snps)
  expect_equal(1, nrow(tibbles[[7]]))
  expect_equal(
    tibbles[[7]]$snp_id,
    read_snps_file(snps_filename = snps_filename)$snp_id[7]
  )

  #file.remove(variations_rds_filename)
  #expect_false(file.exists(variations_rds_filename))
})
