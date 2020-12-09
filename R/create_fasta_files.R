#' Create a FASTA file with the sequences for each variation
#' @inheritParams default_params_doc
#' @export
create_fasta_files <- function(
  variations_csv_filenames,
  verbose = FALSE
) {
  n_variations_csv_filenames <- length(variations_csv_filenames)
  fasta_filenames <- stringr::str_replace(
    string = variations_csv_filenames,
    pattern = "_variations.csv",
    replacement = ".fasta"
  )

  for (i in seq_len(n_variations_csv_filenames)) {
    if (file.exists(fasta_filenames[i])) {
      if (verbose) {
        message(
          "Skip creating '", fasta_filenames[i], "': ",
          "it is already present"
        )
      }
      next
    }
    fasta_filename <- ncbiperegrine::create_fasta_file(
      variations_csv_filename = variations_csv_filenames[i]
    )
    testthat::expect_equal(fasta_filename, fasta_filenames[i])
  }
  fasta_filenames
}
