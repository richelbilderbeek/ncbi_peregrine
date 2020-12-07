test_that("use", {
  gene_ids_filename <- tempfile()
  n_gene_ids <- 2

  create_gene_ids(
    n_gene_ids = n_gene_ids,
    gene_ids_filename = gene_ids_filename
  )

  t_gene_ids <- read_genes_ids_file(gene_ids_filename)
  expect_equal(nrow(t_gene_ids), n_gene_ids)
})
