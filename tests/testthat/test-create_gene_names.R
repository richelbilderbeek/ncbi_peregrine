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
})
