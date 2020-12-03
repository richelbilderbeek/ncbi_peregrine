test_that("use", {
  gene_names_filename <- system.file(
    "extdata", "gene_names.csv",
    package = "ncbiperegrine"
  )
  folder_name <- tempfile()
  files <- create_gene_name_snps(
    gene_names_filename = gene_names_filename,
    folder_name = folder_name
  )
  expect_true(all(file.exists(files)))
})

test_that("use in current working directory", {
  gene_names_filename <- system.file(
    "extdata", "gene_names.csv",
    package = "ncbiperegrine"
  )
  files <- create_gene_name_snps(
    gene_names_filename = gene_names_filename,
    folder_name = getwd()
  )
  expect_true(all(file.exists(files)))
  file.remove(files)
  expect_true(all(!file.exists(files)))
})
