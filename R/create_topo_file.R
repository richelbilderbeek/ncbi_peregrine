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

  # Start clean
  if (!file.exists(topo_filename)) {
    return(
      ncbiperegrine::create_topo_file_from_scratch(
        fasta_filename = fasta_filename,
        verbose = verbose
      )
    )
  }

  # Do nothing if all has been done already
  t_sequences <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)
  testthat::expect_true(file.exists(topo_filename))
  t_topology <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)
  if ((nrow(t_sequences) == 0 && nrow(t_topology) == 0)
    || (length(t_topology$sequence) > 0
      && length(t_sequences$sequence) == length(t_topology$sequence)
      && all(nchar(t_sequences$sequence) == nchar(t_topology$sequence))
    )
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
