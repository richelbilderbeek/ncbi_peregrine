#' Create a \code{.topo} file from scratch
#' @inheritParams default_params_doc
#' @export
create_topo_file_from_scratch <- function(fasta_filename,
  verbose = FALSE
) {
  testthat::expect_true(file.exists(fasta_filename))
  topo_filename <- stringr::str_replace(
    string = fasta_filename,
    pattern = ".fasta",
    replacement = ".topo"
  )

  # It must not exist, else the topo file is not created from scratch
  testthat::expect_false(file.exists(topo_filename))

  t_sequences <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)

  if (verbose) {
    message(
      "Creating ", topo_filename, " from ", nrow(t_sequences), " sequences"
    )
  }
  # Predict the topology
  t_topology <- pureseqtmr::predict_topology(fasta_filename = fasta_filename)

  # Convert to (pseudo-FASTA) topology file
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_topology,
    fasta_filename = topo_filename
  )
  topo_filename
}
