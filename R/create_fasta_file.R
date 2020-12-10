#' Create a FASTA file with the sequences for each variation
#' @inheritParams default_params_doc
#' @export
create_fasta_file <- function(
  variations_csv_filename
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
      fasta_filename = fasta_filename
    )
  } else {
    # Create an empty file
    readr::write_lines(x = c(), fasta_filename)
  }
  fasta_filename
}
