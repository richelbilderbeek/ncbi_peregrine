test_that("use", {
  variations_csv_filename <- system.file(
    "extdata",
    "1956_variations.csv",
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(variations_csv_filename)))
  fasta_filename <- create_fasta_file(
    variations_csv_filename = variations_csv_filename
  )
  expect_true(file.exists(fasta_filename))
  t_variations <- read_variations_csv_file(variations_csv_filename)
  t_sequences <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)

  expect_equal(
    t_sequences$name,
    stringr::str_replace(
      string = t_variations$variation,
      pattern = ":.*",
      replacement = ""
    )
  )
  # file.remove(fasta_filename)
  # expect_true(all(!file.exists(fasta_filename)))
})
