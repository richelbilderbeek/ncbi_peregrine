test_that("use", {
  variations_csv_filename <- tempfile(fileext = "_variations.csv")
  file.copy(
    from = system.file(
      "extdata",
      "1956_variations.csv",
      package = "ncbiperegrine"
    ),
    to = variations_csv_filename
  )
  topo_filename <- tempfile(fileext = ".topo")
  file.copy(
    from = system.file(
      "extdata",
      "1956.topo",
      package = "ncbiperegrine"
    ),
    to = topo_filename
  )
  expect_true(file.exists(variations_csv_filename))
  expect_true(file.exists(topo_filename))
  in_tmh_filename <- create_is_in_tmh_file(
    variations_csv_filename = variations_csv_filename,
    topo_filename = topo_filename
  )
  expect_true(file.exists(in_tmh_filename))
  t_in_tmh <- read_is_in_tmh_file(in_tmh_filename)
  t_variations <- read_variations_csv_file(variations_csv_filename)
  expect_equal(t_variations$variation, t_in_tmh$variation)

})
