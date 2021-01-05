#' Create the topology files from the FASTA files
#' @inheritParams default_params_doc
#' @export
create_topo_file <- function(
  fasta_filename,
  verbose = FALSE
) {
  testthat::expect_true(file.exists(fasta_filename))

  topo_filename <- stringr::str_replace(
    string = fasta_filename,
    pattern = ".fasta",
    replacement = ".topo"
  )

  t_sequences <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)

  # Start clean
  if (!file.exists(topo_filename)) {
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
    return(topo_filename)
  }

  # Do nothing if all has been done already
  testthat::expect_true(file.exists(topo_filename))
  t_topology <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)
  if (nrow(t_sequences) == nrow(t_topology)
    && nchar(t_sequences$sequence) == nchar(t_topology$sequence)
    && all(nchar(t_topology$sequence) > 0)
  ) {
    if (verbose) {
      message("Already processed all ", nrow(t_topology), " topologies")
    }
    return(topo_filename)
  }

  # Continue with known topologies
  if (length(t_topology$name) == 0) {
    t_topology <- tibble::tibble(
      name = t_sequences$name,
      sequence = ""
    )
  } else {
    # Append
    t_topology <- tibble::add_row(
      t_topology,
      name = t_sequences$name[-seq_len(length(t_topology$name))],
      sequence = ""
    )
  }

  testthat::expect_equal(nrow(t_topology), nrow(t_sequences))
  indices <- which(t_topology$sequence == "")
  testthat::expect_true(length(indices) > 0)

  if (verbose) {
    message(
      "Predicting an additional ", length(indices),
      " topologies from ", nrow(t_sequences), " sequences"
    )
  }

  t_topology$sequence[indices] <- pureseqtmr::predict_topologies_from_sequences(
    protein_sequences = t_sequences$sequence[indices]
  )

  pureseqtmr::save_tibble_as_fasta_file(
    t = t_topology,
    fasta_filename = topo_filename
  )
  topo_filename
}
