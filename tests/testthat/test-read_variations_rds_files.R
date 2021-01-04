test_that("use", {
  variations_rds_filenames <- system.file(
    "extdata",
    c("1956_variations.rds", "348_variations.rds"),
    package = "ncbiperegrine"
  )
  t_variationses <- read_variations_rds_files(
    variations_rds_filenames = variations_rds_filenames
  )
  expect_equal(length(t_variationses), length(variations_rds_filenames))
  for (t_variations in t_variationses) {
    for (t in t_variations) {
      expect_true(tibble::is_tibble(t))
      expect_equal(names(t), c("snp_id", "variation"))
    }
  }
})
