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

test_that("use", {
  skip("https://github.com/richelbilderbeek/bbbq_article/issues/134")
  variations_rds_filename <- "~/GitHubs/ncbi_peregrine/scripts/100129361_variations.rds"
  file.exists(variations_rds_filename)
  t_variations <- read_variations_rds_file(
    variations_rds_filename = variations_rds_filename
  )
  t_variations[  purrr::map_lgl(t_variations, function(t) nrow(t) > 0) ]
  t_variations[  purrr::map_lgl(t_variations, function(t) sum(t$snp_id == 1592146326) > 0) ]
  # No SNP with ID 1592146326 found in the variations acting upon 100129361
  sum(purrr::map_lgl(t_variations, function(t) sum(t$snp_id == 1592146326) > 0))
})
