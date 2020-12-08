test_that("use", {
  gene_ids_filename <- system.file(
    "extdata",
    "gene_ids.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(gene_ids_filename))
  t_gene_ids <- read_genes_ids_file(gene_ids_filename)
  expect_true(tibble::is_tibble(t_gene_ids))
  expect_equal("gene_id", names(t_gene_ids))
  expect_equal(3, nrow(t_gene_ids))
  expect_equal(t_gene_ids$gene_id, c(1956, 7124, 348))
})
