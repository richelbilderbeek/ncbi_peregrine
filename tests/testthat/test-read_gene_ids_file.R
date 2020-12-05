test_that("use", {
  gene_ids_filename <- system.file(
    "extdata",
    "gene_ids.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(gene_ids_filename))
  expect_equal(2 * 2, 4)
})
