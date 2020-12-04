test_that("use", {
  gene_names_filename <- system.file(
    "extdata",
    "gene_names.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(gene_names_filename))
  snps_filename <- create_gene_name_snps(
    gene_names_filename = gene_names_filename
  )
  expect_true(file.exists(snps_filename))
  # file.remove(snps_filename)
  # expect_true(!file.exists(snps_filename))
})
