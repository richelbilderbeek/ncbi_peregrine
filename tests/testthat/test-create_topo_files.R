test_that("use", {
  fasta_filenames <- system.file(
    "extdata",
    c("1956.fasta", "348.fasta", "7124.fasta"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(fasta_filenames)))
  topo_filenames <- create_topo_files(
    fasta_filenames = fasta_filenames
  )
  expect_true(all(file.exists(topo_filenames)))
})
