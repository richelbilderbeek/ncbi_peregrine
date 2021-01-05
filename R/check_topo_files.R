#' Check the \code{.topo} files for being valid.
#' Will \link{stop} if not
#' @inheritParams default_params_doc
#' @export
check_topo_files <- function(topo_filenames) {
  for (topo_filename in topo_filenames) {
    tryCatch({
      t_topo <- NA
      testthat::expect_silent({
        t_topo <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)
      })
      testthat::expect_true(all(nchar(t_topo$sequence) > 0))
    }, error = function(e) {
      stop("File ", topo_filename, " is invalid")
    }
    )
  }

}
