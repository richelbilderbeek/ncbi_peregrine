test_that("use", {
  gene_names_filename <- tempfile()
  file.copy(
    from = system.file(
      "extdata",
      "gene_names.csv",
      package = "ncbiperegrine"
    ),
    to = gene_names_filename
  )
  expect_true(file.exists(gene_names_filename))
  snps_filenames <- create_gene_name_snps_files(
    gene_names_filename = gene_names_filename
  )

  # All created files must exist
  expect_true(all(file.exists(snps_filenames)))

  # There must be as many files as there are genes
  t_gene_names <- read_gene_names_file(gene_names_filename)
  expect_equal(nrow(t_gene_names), length(snps_filenames))

  # The files must have the expected names
  expect_equal(
    paste0(t_gene_names$gene_id, "_snps.csv"),
    snps_filenames
  )
})
