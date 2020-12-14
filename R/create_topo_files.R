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

    if (file.exists(topo_filenames[i])) {
      if (verbose) {
        message(
          "Skip creating '", topo_filenames[i], "': it is already present"
        )
      }
      next
    }
    topo_filename <- ncbiperegrine::create_topo_file(
      fasta_filename = fasta_filenames[i]
    )
    testthat::expect_equal(topo_filenames[i], topo_filename)
  }
  topo_filenames
}
