#' Read
#' @inheritParams default_params_doc
#' @export
read_genes_ids_file <- function(gene_ids_filename) {
  testthat::expect_true(file.exists(gene_ids_filename))

  # Must have exactly these columns
  suppressMessages({
    t <- readr::read_csv(
      file = gene_ids_filename,
      n_max = 1
    )
    testthat::expect_equal(names(t), "gene_id")
  })

  readr::read_csv(
    file = gene_ids_filename,
    col_types = readr::cols(
      gene_id = readr::col_double()
    )
  )
}
