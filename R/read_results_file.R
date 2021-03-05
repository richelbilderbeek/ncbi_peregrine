#' Read the results file and removes duplicates
#' @inheritParams default_params_doc
#' @export
read_results_file <- function(results_filename) {
  dplyr::distinct(
    readr::read_csv(
      results_filename,
      col_types = readr::cols(
        gene_id = readr::col_double(),
        gene_name = readr::col_character(),
        snp_id = readr::col_double(),
        variation = readr::col_character(),
        is_in_tmh = readr::col_logical(),
        p_in_tmh = readr::col_double()
      )
    )
  )
}
