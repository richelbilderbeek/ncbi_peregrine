test_that("use", {
  gene_names_filename <- system.file(
    "extdata", "gene_names.csv",
    package = "ncbiperegrine"
  )
  files <- create_gene_name_snps(
    gene_names_filename = gene_names_filename
  )
  expect_true(all(file.exists(files)))
  file.remove(files)
  expect_true(all(!file.exists(files)))
})
