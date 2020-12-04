#' Create the \code{[gene_name]_is_in_tmh.csv} files.
#' @export
create_is_in_tmh_files <- function(
  variations_csv_filenames,
  topo_filenames
) {
  testthat::expect_equal(
    length(variations_csv_filenames),
    length(topo_filenames)
  )
  n <- length(variations_csv_filenames)
  is_in_tmh_filenames <- rep(NA, n)
  for (i in seq_len(n)) {
    is_in_tmh_filenames[i] <- ncbiperegrine::create_is_in_tmh_file(
      variations_csv_filename = variations_csv_filenames[i],
      topo_filename = topo_filenames[i]
    )
  }
  is_in_tmh_filenames
}
