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
  testthat::expect_true(all(file.exists(variations_csv_filenames)))
  testthat::expect_equal(
    length(variations_csv_filenames),
    length(topo_filenames)
  )
  n <- length(topo_filenames)
  is_in_tmh_filenames <- rep(NA, n)
  for (i in seq_len(n)) {
    is_in_tmh_filenames[i] <- ncbiperegrine::create_is_in_tmh_file(
      variations_csv_filename = variations_csv_filenames[i],
      topo_filename = topo_filenames[i],
      verbose = verbose
    )
  }
  is_in_tmh_filenames
}
