test_that("use", {
  skip("WIP")
  is_in_tmh_filename <- system.file(
    "extdata",
    "1956_is_in_tmh.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(is_in_tmh_filename))
  t_is_in_tmh <- read_is_in_tmh_file(is_in_tmh_filename = is_in_tmh_filename)
  expect_true(tibble::is_tibble(t_is_in_tmh))

  expect_equal(c("variation", "is_in_tmh", "p_in_tmh"), names(t_is_in_tmh))
  expect_equal(nrow(t_is_in_tmh), 4)
})
