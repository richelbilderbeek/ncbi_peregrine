test_that("use", {
  variations_csv_filename <- system.file(
    "extdata",
    "1956_variations.csv",
    package = "ncbiperegrine"
  )
  t_variations <- read_variations_csv_file(
    variations_csv_filename = variations_csv_filename
  )
  expect_true(tibble::is_tibble(t_variations))
  expect_equal(names(t_variations), c("snp_id", "variation"))
  expect_equal(nrow(t_variations), 4)
})
