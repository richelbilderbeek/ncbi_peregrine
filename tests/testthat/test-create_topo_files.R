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

  # Simplify FASTAs to 1 and 2 sequences
  pureseqtmr::save_tibble_as_fasta_file(
    t = pureseqtmr::load_fasta_file_as_tibble(
      fasta_filename = fasta_filenames[1]
    )[1, ],
    fasta_filename = fasta_filenames[1]
  )
  pureseqtmr::save_tibble_as_fasta_file(
    t = pureseqtmr::load_fasta_file_as_tibble(
      fasta_filename = fasta_filenames[2]
    )[1:2, ],
    fasta_filename = fasta_filenames[2]
  )


  topo_filenames <- create_topo_files(
    fasta_filenames = fasta_filenames
  )
  expect_true(all(file.exists(topo_filenames)))
  expect_equal(length(topo_filenames), length(fasta_filenames))
})

test_that("Need to do all sequences", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  fasta_filename <- tempfile(tmpdir = folder_name, fileext = ".fasta")
  file.copy(
    from = system.file(
      "extdata",
      "1956.fasta",
      package = "ncbiperegrine"
    ),
    to = fasta_filename
  )
  expect_true(file.exists(fasta_filename))

  # Use only 1 sequences
  pureseqtmr::save_tibble_as_fasta_file(
    t = pureseqtmr::load_fasta_file_as_tibble(fasta_filename)[1, ],
    fasta_filename = fasta_filename
  )

  expect_message(
    create_topo_files(
      fasta_filenames = fasta_filename,
      verbose = TRUE
    ),
    "Creating .*\\.topo from 1 sequences"
  )
})

test_that("skip if already done", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  fasta_filename <- tempfile(tmpdir = folder_name, fileext = ".fasta")
  file.copy(
    from = system.file(
      "extdata",
      "1956.fasta",
      package = "ncbiperegrine"
    ),
    to = fasta_filename
  )
  expect_true(file.exists(fasta_filename))
  topo_filename <- stringr::str_replace(
    string = fasta_filename,
    pattern = ".fasta",
    replacement = ".topo"
  )
  file.copy(
    from = system.file(
      "extdata",
      "1956.topo",
      package = "ncbiperegrine"
    ),
    to = topo_filename
  )
  expect_true(file.exists(topo_filename))

  # Verify that test if already done
  t_fasta <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)
  t_topo <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)
  expect_equal(nrow(t_fasta), nrow(t_topo))

  expect_message(
    create_topo_files(
      fasta_filenames = fasta_filename,
      verbose = TRUE
    ),
    "Already processed all 4 topologies"
  )
})

test_that("Continue from some known sequences", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  fasta_filename <- tempfile(tmpdir = folder_name, fileext = ".fasta")
  file.copy(
    from = system.file(
      "extdata",
      "1956.fasta",
      package = "ncbiperegrine"
    ),
    to = fasta_filename
  )
  expect_true(file.exists(fasta_filename))
  topo_filename <- stringr::str_replace(
    string = fasta_filename,
    pattern = ".fasta",
    replacement = ".topo"
  )
  file.copy(
    from = system.file(
      "extdata",
      "1956.topo",
      package = "ncbiperegrine"
    ),
    to = topo_filename
  )
  expect_true(file.exists(topo_filename))

  # Verify that test if already done
  t_fasta <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)
  t_topo <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)

  # Of the topology, remove the last prediction
  pureseqtmr::save_tibble_as_fasta_file(
    t = pureseqtmr::load_fasta_file_as_tibble(topo_filename)[1:3, ],
    fasta_filename = topo_filename
  )

  expect_message(
    create_topo_files(
      fasta_filenames = fasta_filename,
      verbose = TRUE
    ),
    "Predicting an additional 1 topologies from 4 sequences"
  )
})
