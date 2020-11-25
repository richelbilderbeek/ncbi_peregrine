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
  t_sequences <- tibble::tibble(
    protein_id = unique(
      ncbi::extract_protein_ids_from_variations(t_variations$variation)
    ),
    sequence = NA
  )
  sequences <- ncbi::fetch_sequence_from_protein_id(
    t_sequences$protein_id
  )
  # Note that 'names(sequences)' contains the full names again
  t_sequences$sequence <- sequences

  # Convert to FASTA file
  fasta_text <- rep(NA, nrow(t_sequences) * 2)
  fasta_text[seq(1, (nrow(t_sequences) * 2) - 1, by = 2)] <-
    paste0(">", t_sequences$protein_id)
  fasta_text[seq(2, (nrow(t_sequences) * 2) - 0, by = 2)] <-
    t_sequences$sequence
  testthat::expect_true(all(!is.na(fasta_text)))
  readr::write_lines(x = fasta_text, file = t$fasta_filename[i])
  testthat::expect_true(file.exists(t$fasta_filename[i]))
}

readr::write_lines(
  x = Sys.time(),
  file = "create_fasta_files_is_done.txt"
)
