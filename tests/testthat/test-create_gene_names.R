test_that("use", {
  gene_ids_filename <- tempfile()
  file.copy(
      from = system.file(
      "extdata", "gene_ids.csv",
      package = "ncbiperegrine"
    ),
    to = gene_ids_filename
  )
  gene_names_filename <- tempfile()
  create_gene_names(
    gene_ids_filename = gene_ids_filename,
    gene_names_filename = gene_names_filename
  )
  expect_true(file.exists(gene_names_filename))

  t_gene_ids <- read_genes_ids_file(gene_ids_filename)
  t_gene_names <- read_gene_names_file(gene_names_filename)
  expect_equal(nrow(t_gene_ids), nrow(t_gene_names))
  expect_equal(t_gene_ids$gene_id, t_gene_names$gene_id)
  expect_equal(t_gene_names$gene_name, c("EGFR", "TNF", "APOE"))
})
