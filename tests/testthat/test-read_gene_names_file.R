test_that("use", {
  gene_names_filename <- system.file(
    "extdata", "gene_names.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(gene_names_filename))

  t_gene_names <- read_gene_names_file(gene_names_filename)
  expect_true(tibble::is_tibble(t_gene_names))
  expect_equal(c("gene_id", "gene_name"), names(t_gene_names))
  expect_equal(3, nrow(t_gene_names))
})

test_that("use on gene_ids.csv gives error", {
  gene_ids_filename <- system.file(
    "extdata", "gene_ids.csv",
    package = "ncbiperegrine"
  )
  expect_error(
    read_gene_names_file(
      gene_names_filename = gene_ids_filename
    )
  )
})
