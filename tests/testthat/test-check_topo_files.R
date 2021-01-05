test_that("use", {
  # richel@N141CU:~/GitHubs/ncbi_peregrine/inst/extdata$ cat 7124.topo | wc
  #      12      12    1482
  # richel@N141CU:~/GitHubs/ncbi_peregrine/inst/extdata$ cat 1956.topo | wc
  #       8       8    4522
  topo_filenames <- system.file(
    "extdata",
    c("7124.topo", "1956.topo"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(topo_filenames)))
  expect_silent(check_topo_files(topo_filenames = topo_filenames))
})

test_that("detect error", {
  topo_filenames <- system.file(
    "extdata",
    "incomplete.topo",
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(topo_filenames)))
  expect_error(
    check_topo_files(topo_filenames = topo_filenames),
    "incomplete\\.topo"
  )
})
