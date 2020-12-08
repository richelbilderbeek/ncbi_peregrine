test_that("use", {
  variations_csv_filenames <- system.file(
    "extdata",
    c("1956_variations.csv", "348_variations.csv"),
    package = "ncbiperegrine"
  )
  topo_filenames <- system.file(
    "extdata",
    c("1956.topo", "348.topo"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(variations_csv_filenames)))
  expect_true(all(file.exists(topo_filenames)))
  in_tmh_filenames <- create_is_in_tmh_files(
    variations_csv_filenames = variations_csv_filenames,
    topo_filenames = topo_filenames
  )
  expect_true(all(file.exists(in_tmh_filenames)))
})
