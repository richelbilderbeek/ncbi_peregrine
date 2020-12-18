#' Create the topology files from the FASTA files
#' @inheritParams default_params_doc
#' @export
create_topo_files <- function(
  fasta_filenames,
  verbose = FALSE
) {
  n_fasta_filenames <- length(fasta_filenames)
  topo_filenames <- stringr::str_replace(
    string = fasta_filenames,
    pattern = ".fasta",
    replacement = ".topo"
  )

  for (i in seq_len(n_fasta_filenames)) {
    if (verbose) {
      message(i, "/", n_fasta_filenames, ": ", fasta_filenames[i])
    }

    topo_filename <- ncbiperegrine::create_topo_file(
      fasta_filename = fasta_filenames[i],
      verbose = verbose
    )
    testthat::expect_equal(topo_filenames[i], topo_filename)
  }
  topo_filenames
}
