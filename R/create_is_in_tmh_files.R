#' Create the \code{[gene_name]_is_in_tmh.csv} files.
#' @inheritParams default_params_doc
#' @export
create_is_in_tmh_files <- function(
  topo_filenames,
  verbose = FALSE
) {
  testthat::expect_true(all(file.exists(topo_filenames)))
  variations_csv_filenames <- stringr::str_replace(
    string = topo_filenames,
    pattern = ".topo",
    replacement = "_variations.csv"
  )
  is_in_tmh_filenames <- stringr::str_replace(
    string = topo_filenames,
    pattern = ".topo",
    replacement = "_is_in_tmh.csv"
  )
  testthat::expect_true(all(file.exists(variations_csv_filenames)))
  testthat::expect_equal(
    length(variations_csv_filenames),
    length(topo_filenames)
  )
  testthat::expect_equal(
    length(variations_csv_filenames),
    length(is_in_tmh_filenames)
  )
  n <- length(topo_filenames)

  for (i in seq_len(n)) {
    if (file.exists(is_in_tmh_filenames[i])) {
      if (verbose) {
        message(
          "Skip creating '", is_in_tmh_filenames[i], "': it is already present"
        )
      }
      next
    }
    is_in_tmh_filename <- ncbiperegrine::create_is_in_tmh_file(
      variations_csv_filename = variations_csv_filenames[i],
      topo_filename = topo_filenames[i],
      verbose = verbose
    )
    testthat::expect_equal(is_in_tmh_filenames[i], is_in_tmh_filename)
  }
  is_in_tmh_filenames
}
