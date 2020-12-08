#' Read teh \code{gene_names.csv} file
#' @inheritParams default_params_doc
#' @export
read_gene_names_file <- function(gene_names_filename) {
  testthat::expect_true(file.exists(gene_names_filename))
  readr::read_csv(
    file = gene_names_filename,
    col_types = readr::cols(
      gene_id = readr::col_double(),
      gene_name = readr::col_character()
    )
  )
}
