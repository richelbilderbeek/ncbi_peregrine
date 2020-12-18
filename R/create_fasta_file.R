#' Create a FASTA file with the sequences for each variation
#' @inheritParams default_params_doc
#' @export
create_fasta_file <- function(
  variations_csv_filename,
  verbose = FALSE
) {
  testthat::expect_true(file.exists(variations_csv_filename))

  fasta_filename <- stringr::str_replace(
    string = variations_csv_filename,
    pattern = "_variations.csv",
    replacement = ".fasta"
  )

  # The CSV filename
  t_variations <- ncbiperegrine::read_variations_csv_file(
    variations_csv_filename = variations_csv_filename
  )

  if (nrow(t_variations) == 0) {
    if (verbose) {
      message("Zero variations results in zero protein sequences to look up")
    }
    # There were none protein sequence to fetch ...
    # Create an empty file
    readr::write_lines(x = c(), fasta_filename)
    return(fasta_filename)
  }

  # There may be duplicates in 'protein_id'
  # These are kept, to ensure tables have the same number of rows
  t_sequences <- tibble::tibble(
    protein_id = ncbi::extract_protein_ids_from_variations(
      t_variations$variation
    ),
    sequence = NA
  )

  # Add sequences if these are already known
  if (file.exists(fasta_filename)) {
    t_known <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)
    known_sequences <- t_known$sequence
    n_known <- length(known_sequences)
    t_sequences$sequence[seq_len(n_known)] <- known_sequences
  }
  testthat::expect_equal(nrow(t_variations), nrow(t_sequences))

  n_todo <- sum(is.na(t_sequences$sequence))
  if (n_todo == 0) {
    if (verbose) {
      message("Already fetched all ", nrow(t_sequences), " protein sequences")
    }
    return(fasta_filename)
  }
  if (verbose) {
    message(
      "Fetching ", n_todo, "/", nrow(t_sequences), " new protein sequences"
    )
  }

  indices <- which(is.na(t_sequences$sequence))
  sequences <- sprentrez::fetch_sequences_from_protein_ids(
    t_sequences$protein_id[indices]
  )
  testthat::expect_equal(length(indices), length(sequences))
  # Note that 'names(sequences)' contains the full names again
  t_sequences$sequence[indices] <- sequences

  # All NAs are filled up now!
  testthat::expect_equal(0, sum(is.na(t_sequences$sequence)))

  # Convert to FASTA file
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_sequences,
    fasta_filename = fasta_filename
  )
  fasta_filename
}
