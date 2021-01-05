test_that("use", {
  topo_filename <- system.file(
    "extdata", "100129361.topo",
    package = "ncbiperegrine"
  )
  t_topo <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)
  # According to the NCBI website,
  # see https://github.com/richelbilderbeek/bbbq_article/issues/134#issuecomment-754453117 # nolint indeed a long line
  expect_equal(nchar(t_topo$sequence[1]), 68)
})
