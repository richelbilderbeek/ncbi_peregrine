test_that("use", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  source_fasta_filenames <- system.file(
    "extdata",
    c("1956.fasta", "348.fasta"),
    package = "ncbiperegrine"
  )
  fasta_filenames <- file.path(folder_name, basename(source_fasta_filenames))
  file.copy(
    from = source_fasta_filenames,
    to = fasta_filenames
  )
  expect_true(all(file.exists(fasta_filenames)))
  expect_equal(2, length(fasta_filenames))
  topo_filenames <- create_topo_files(
    fasta_filenames = fasta_filenames
  )
  expect_true(all(file.exists(topo_filenames)))
  expect_equal(length(topo_filenames), length(fasta_filenames))
})

test_that("skip existing topo files", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  source_fasta_filenames <- system.file(
    "extdata",
    c("1956.fasta", "348.fasta"),
    package = "ncbiperegrine"
  )
  fasta_filenames <- file.path(folder_name, basename(source_fasta_filenames))
  file.copy(
    from = source_fasta_filenames,
    to = fasta_filenames
  )
  source_topo_filenames <- system.file(
    "extdata",
    c("1956.topo"),
    package = "ncbiperegrine"
  )
  topo_filenames <- file.path(folder_name, basename(source_topo_filenames))
  file.copy(
    from = source_topo_filenames,
    to = topo_filenames
  )
  expect_true(all(file.exists(fasta_filenames)))
  expect_true(all(file.exists(topo_filenames)))
  expect_equal(1, length(topo_filenames))

  expect_message({
    topo_filenames <- create_topo_files(
      fasta_filenames = fasta_filenames,
      verbose = TRUE
    )
    },
    "Skip creating '.*.topo': it is already present"
  )
  expect_true(all(file.exists(topo_filenames)))
  expect_equal(2, length(topo_filenames))
})
