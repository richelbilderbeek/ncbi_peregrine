#' Create a FASTA file with the sequences for each variation
#' @inheritParams default_params_doc
#' @export
create_fasta_files <- function(
  variations_csv_filenames
) {
  n_variations_csv_filenames <- length(variations_csv_filenames)
  fasta_filenames <- rep(NA, n_variations_csv_filenames)

  for (i in seq_len(n_variations_csv_filenames)) {
    fasta_filenames[i] <- ncbiperegrine::create_fasta_file(
      variations_csv_filename = variations_csv_filenames[i]
    )
  }
  fasta_filenames
}
