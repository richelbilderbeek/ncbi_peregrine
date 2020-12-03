test_that("use", {
  variations_csv_filenames <- system.file(
    "extdata",
    c("1956_variations.csv", "348_variations.csv", "7124_variations.csv"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(variations_csv_filenames)))
  fasta_filenames <- create_fasta_files(
    variations_csv_filenames = variations_csv_filenames
  )
  expect_true(all(file.exists(fasta_filenames)))

  file.remove(fasta_filenames)
  expect_true(all(!file.exists(fasta_filenames)))
})
