test_that("use", {
  snps_filename <- system.file(
    "extdata", "7124_snps.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(snps_filename))
  snps <- read_snps_file(snps_filename)
  expect_true(tibble::is_tibble(snps))
  expect_equal("snp_id", names(snps))
  expect_equal(nrow(snps), 1254)
})
