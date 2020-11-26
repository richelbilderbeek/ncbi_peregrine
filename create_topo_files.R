t <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)
testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$fasta_filename <- paste0(t$gene_id, ".fasta")
t$topo_filename <- paste0(t$gene_id, ".topo")

# i <- 1
# i <- 67
for (i in seq_len(nrow(t))) {

  # The gene
  gene_name <- t$gene_name[i]
  message(i, "/", nrow(t), ": ", gene_name)

  # The FASTA filename
  fasta_filename <- t$fasta_filename[i]
  testthat::expect_true(file.exists(fasta_filename))
  t_fasta  <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)

  # Predict the topology
  t_topology <- pureseqtmr::predict_topology(fasta_filename = fasta_filename)
  testthat::expect_equal(
    nchar(t_fasta$sequence),
    nchar(t_topology$topology)
  )

  # Convert to (pseudo-FASTA) topology file
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_topology,
    fasta_filename = t$topo_filename[i]
  )
  testthat::expect_true(file.exists(t$topo_filename[i]))
}

readr::write_lines(
  x = Sys.time(),
  file = "create_topo_files_is_done.txt"
)
