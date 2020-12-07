#' Read
#' @export
read_genes_ids_file <- function(gene_ids_filename) {
  testthat::expect_true(file.exists(gene_ids_filename))
  readr::read_csv(
    file = gene_ids_filename,
    col_types = readr::cols(
      gene_id = readr::col_double()
    )
  )
}
