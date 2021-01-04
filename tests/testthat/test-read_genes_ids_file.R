test_that("use", {
  gene_ids_filename <- system.file(
    "extdata",
    "gene_ids.csv",
    package = "ncbiperegrine"
  )
  expect_silent(read_genes_ids_file(gene_ids_filename))
})

test_that("use on gene_names.csv gives error", {
  gene_names_filename <- system.file(
    "extdata",
    "gene_names.csv",
    package = "ncbiperegrine"
  )
  expect_error(
    read_genes_ids_file(
      gene_ids_filename = gene_names_filename
    )
  )
})
