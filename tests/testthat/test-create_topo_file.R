test_that("use", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  fasta_filename <- tempfile(fileext = ".fasta")
  file.copy(
    from = system.file(
      "extdata",
      "1956.fasta",
      package = "ncbiperegrine"
    ),
    to = fasta_filename
  )
  expect_true(file.exists(fasta_filename))
  topo_filename <- create_topo_file(
    fasta_filename = fasta_filename
  )
  expect_true(file.exists(topo_filename))

  t_fasta <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)
  t_topo <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)

  # Names must match
  expect_equal(
    t_fasta$name,
    t_topo$name
  )
  # Sequences must have the same number of characters
  expect_equal(
    nchar(t_fasta$sequence),
    nchar(t_topo$sequence)
  )
})
