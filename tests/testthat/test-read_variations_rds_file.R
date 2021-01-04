test_that("use", {
  variations_rds_filename <- system.file(
    "extdata",
    "1956_variations.rds",
    package = "ncbiperegrine"
  )
  t_variations <- read_variations_rds_file(
    variations_rds_filename = variations_rds_filename
  )
  for (t in t_variations) {
    expect_true(tibble::is_tibble(t))
    expect_equal(names(t), c("snp_id", "variation"))
  }
})
