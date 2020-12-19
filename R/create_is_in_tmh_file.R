#' Create one \code{[gene_name]_is_in_tmh.csv} file.
#' @inheritParams default_params_doc
#' @export
create_is_in_tmh_file <- function(
  variations_csv_filename,
  topo_filename,
  verbose = FALSE
) {
  testthat::expect_equal(
    length(variations_csv_filename),
    length(topo_filename)
  )
  testthat::expect_true(file.exists(variations_csv_filename))
  testthat::expect_true(file.exists(topo_filename))
  is_in_tmh_filename <- stringr::str_replace(
    string = variations_csv_filename,
    pattern = "_variations.csv",
    replacement = "_is_in_tmh.csv"
  )

  # The variations filename
  t_variations  <- ncbiperegrine::read_variations_csv_file(
    variations_csv_filename
  )

  # The topo filename
  t_topo  <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)

  # If not, the topo file may need to be updated, which probably
  # means that the FASTA file needs to be updated
  testthat::expect_equal(nrow(t_variations), nrow(t_topo))

  if (nrow(t_topo) == 0) {
    t_is_in_tmh <- tibble::tibble(
      variation = character(0),
      is_in_tmh = logical(0),
      p_in_tmh = double(0)
    )

  } else {

    # Score
    t_is_in_tmh <- tibble::tibble(
      variation = t_variations$variation,
      is_in_tmh = NA,
      p_in_tmh = NA
    )

    # Determine in_in_tmh
    for (variation_index in seq(1, nrow(t_is_in_tmh))) {
      if (verbose) {
        message(
          variation_index, "/", nrow(t_is_in_tmh), ": ",
          t_variations$variation[variation_index]
        )
      }
      tryCatch({
        this_variation <- ncbi::parse_hgvs(
          t_variations$variation[variation_index]
        )
        if (this_variation$from != this_variation$to) {
          pos <- this_variation$pos
          t_is_in_tmh$is_in_tmh[variation_index] <- "1" == stringr::str_sub(
            t_topo$sequence[variation_index], pos, pos)
              # Determine p_in_tmh
            t_is_in_tmh$p_in_tmh <- stringr::str_count(t_topo$sequence, "1") /
                nchar(t_topo$sequence)
        }
      }, error = function(e) {
          # Valid reasons to skip
          testthat::expect_match(
            e$message,
            "Do not accept (frame shifts|extensions|insertions|deletions|delins|duplications|repeated sequences)" # nolint indeed a long error regexp
          )
        }
      )
    }
  }
  # Save
  readr::write_csv(
    x = t_is_in_tmh,
    file = is_in_tmh_filename
  )
  testthat::expect_true(file.exists(is_in_tmh_filename))
  is_in_tmh_filename
}
