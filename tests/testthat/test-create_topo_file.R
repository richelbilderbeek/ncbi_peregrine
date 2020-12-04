test_that("use", {
  fasta_filename <- system.file(
    "extdata",
    "1956.fasta",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(fasta_filename))
  topo_filename <- create_topo_file(
    fasta_filename = fasta_filename
  )
  expect_true(file.exists(topo_filename))

  t_fasta  <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)
  t_topo  <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)
  expect_equal(
    t_fasta$name,
    t_topology$name
  )
  expect_equal(
    nchar(t_fasta$sequence),
    nchar(t_topology$topology)
  )

  #file.remove(topo_filename)
  ##expect_true(all(!file.exists(topo_filename)))
})
