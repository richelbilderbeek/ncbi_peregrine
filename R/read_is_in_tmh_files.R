#' Read \code{[gene_id]_is_in_tmh.csv} files
#' @inheritParams default_params_doc
#' @export
read_is_in_tmh_files <- function(is_in_tmh_filenames) {
  testthat::expect_true(all(file.exists(is_in_tmh_filenames)))
  t_is_in_tmh <- list()
  n <- length(is_in_tmh_filenames)
  for (i in seq_len(n)) {
    t <- ncbiperegrine::read_is_in_tmh_file(is_in_tmh_filenames[i])
    t_is_in_tmh[[i]] <- t
  }
  t_is_in_tmh <- dplyr::bind_rows(t_is_in_tmh)
  # If is_in_tmh is TRUE or FALSE,
  # then the p_in_tmh must be in range [0,1]
  testthat::expect_equal(
    0,
    sum(!is.na(t_is_in_tmh$is_in_tmh) & is.na(t_is_in_tmh$p_in_tmh))
  )
  t_is_in_tmh
}
