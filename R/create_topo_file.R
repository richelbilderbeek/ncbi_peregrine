#' Create the topology files from the FASTA files
#' @inheritParams default_params_doc
#' @export
create_topo_file <- function(fasta_filename) {
  testthat::expect_true(file.exists(fasta_filename))

  topo_filename <- stringr::str_replace(
    string = fasta_filename,
    pattern = ".fasta",
    replacement = ".topo"
  )

  # Predict the topology
  t_topology <- pureseqtmr::predict_topology(fasta_filename = fasta_filename)

  # Convert to (pseudo-FASTA) topology file
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_topology,
    fasta_filename = topo_filename
  )

  topo_filename
}
