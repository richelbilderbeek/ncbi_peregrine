test_that("use", {
  is_in_tmh_filenames <- system.file(
    "extdata",
    c("1956_is_in_tmh.csv", "7124_is_in_tmh.csv", "348_is_in_tmh.csv"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(is_in_tmh_filenames)))
  t_is_in_tmh <- read_is_in_tmh_files(is_in_tmh_filenames = is_in_tmh_filenames)
  expect_true(tibble::is_tibble(t_is_in_tmh))
  expect_equal(c("variation", "is_in_tmh", "p_in_tmh"), names(t_is_in_tmh))
  expect_equal(nrow(t_is_in_tmh), 80)
})
