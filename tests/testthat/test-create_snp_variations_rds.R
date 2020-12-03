test_that("use", {
  skip("WIP")
  gene_names_filename <- system.file(
    "extdata", "gene_names.csv",
    package = "ncbiperegrine"
  )
  variations_rds_filenames <- create_snp_variations_rds(
    gene_names_filename = gene_names_filename
  )
  expect_true(all(file.exists(variations_rds_filenames)))
  file.remove(variations_rds_filenames)
  expect_true(all(!file.exists(variations_rds_filenames)))
})
