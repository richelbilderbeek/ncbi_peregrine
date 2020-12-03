test_that("use", {
  filename <- tempfile()
  n_gene_ids <- 2

  create_gene_ids(
    n_gene_ids = n_gene_ids,
    filename = filename
  )

  expect_true(file.exists(filename))
  t <- readr::read_csv(
    file = filename,
    col_types = readr::cols(
      gene_id = readr::col_double()
    )
  )
  expect_equal(names(t), "gene_id")
})
