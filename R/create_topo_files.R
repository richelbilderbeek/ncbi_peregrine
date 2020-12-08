#' Create the topology files from the FASTA files
#' @inheritParams default_params_doc
#' @export
create_topo_files <- function(fasta_filenames) {

  n_fasta_filenames <- length(fasta_filenames)
  topo_filenames <- rep(NA, n_fasta_filenames)
  for (i in seq_len(n_fasta_filenames)) {
    topo_filenames[i] <- ncbiperegrine::create_topo_file(
      fasta_filename = fasta_filenames[i]
    )
  }
  topo_filenames
}
