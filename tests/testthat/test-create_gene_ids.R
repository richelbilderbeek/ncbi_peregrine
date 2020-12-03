test_that("use", {
  gene_ids_filename <- tempfile()
  n_gene_ids <- 2

  create_gene_ids(
    n_gene_ids = n_gene_ids,
    gene_ids_filename = gene_ids_filename
  )

  expect_true(file.exists(gene_ids_filename))
  t <- readr::read_csv(
    file = gene_ids_filename,
    col_types = readr::cols(
      gene_id = readr::col_double()
    )
  )
  expect_equal(names(t), "gene_id")
})
