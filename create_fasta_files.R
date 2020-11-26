t <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)
testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$csv_filename <- paste0(t$gene_id, "_variations.csv")
t$fasta_filename <- paste0(t$gene_id, ".fasta")

# i <- 1
# i <- 67
for (i in seq_len(nrow(t))) {

  # The gene
  gene_name <- t$gene_name[i]
  message(i, "/", nrow(t), ": ", gene_name)

  # The CSV filename
  csv_filename <- t$csv_filename[i]
  testthat::expect_true(file.exists(csv_filename))

  t_variations <- readr::read_csv(
    file = csv_filename,
    col_types = readr::cols(
      snp_id = readr::col_double(),
      variation = readr::col_character()
    )
  )
  # There may be duplicates in 'protein_id'
  # These are kept, to ensure tables have the same number of rows
  t_sequences <- tibble::tibble(
    protein_id = ncbi::extract_protein_ids_from_variations(
      t_variations$variation
    ),
    sequence = NA
  )
  testthat::expect_equal(nrow(t_variations), nrow(t_sequences))
  if (nrow(t_sequences) > 0) {
    sequences <- ncbi::fetch_sequences_from_protein_ids(
      t_sequences$protein_id
    )
    testthat::expect_equal(length(t_sequences$protein_id), length(sequences))
    # Note that 'names(sequences)' contains the full names again
    t_sequences$sequence <- sequences

    # Convert to FASTA file
    pureseqtmr::save_tibble_as_fasta_file(
      t = t_sequences,
      fasta_filename = t$fasta_filename[i]
    )
  } else {
    # Create an empty file
    readr::write_lines(x = c(), t$fasta_filename[i])
  }
  testthat::expect_true(file.exists(t$fasta_filename[i]))
}

readr::write_lines(
  x = Sys.time(),
  file = "create_fasta_files_is_done.txt"
)
