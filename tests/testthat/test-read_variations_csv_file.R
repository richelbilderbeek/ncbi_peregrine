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

test_that("use", {
  skip("https://github.com/richelbilderbeek/bbbq_article/issues/134")
  variations_csv_filename <- "~/GitHubs/ncbi_peregrine/scripts/100129361_variations.csv"
  file.exists(variations_csv_filename)
  t_variations <- read_variations_csv_file(
    variations_csv_filename = variations_csv_filename
  )
  # No SNP with ID 1592146326 found in the variations acting upon 100129361
  t_variations$snp_id == 1592146326
})
