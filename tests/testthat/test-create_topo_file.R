test_that("use, no mock", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  fasta_filename <- tempfile(fileext = ".fasta")
  file.copy(
    from = system.file(
      "extdata",
      "1956.fasta",
      package = "ncbiperegrine"
    ),
    to = fasta_filename
  )
  expect_true(file.exists(fasta_filename))
  topo_filename <- create_topo_file(
    fasta_filename = fasta_filename
  )
  expect_true(file.exists(topo_filename))

  t_fasta <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)
  t_topo <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)

  # Names must match
  expect_equal(
    t_fasta$name,
    t_topo$name
  )
  # Sequences must have the same number of characters
  expect_equal(
    nchar(t_fasta$sequence),
    nchar(t_topo$sequence)
  )
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
    create_topo_file(
      fasta_filename = fasta_filename,
      verbose = TRUE
    ),
    "Creating .*\\.topo from 1 sequences"
  )
})

test_that("skip if already done all 4/4 sequences", {
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
    create_topo_file(
      fasta_filename = fasta_filename,
      verbose = TRUE
    ),
    "Already processed all 4 topologies"
  )
})

test_that("skip if already done all 0 sequences", {
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)

  fasta_filename <- tempfile(tmpdir = folder_name, fileext = ".fasta")
  topo_filename <- stringr::str_replace(
    string = fasta_filename,
    pattern = ".fasta",
    replacement = ".topo"
  )
  t <- tibble::tibble(name = character(0), sequence = character(0))
  pureseqtmr::save_tibble_as_fasta_file(
    t = t,
    fasta_filename = fasta_filename
  )
  pureseqtmr::save_tibble_as_fasta_file(
    t = t,
    fasta_filename = topo_filename
  )
  expect_true(file.exists(fasta_filename))
  expect_true(file.exists(topo_filename))

  # Verify that test if already done
  expect_message(
    create_topo_file(
      fasta_filename = fasta_filename,
      verbose = TRUE
    ),
    "Already processed all 0 topologies"
  )
  expect_true(file.exists(topo_filename))
})

test_that("Continue from some known sequences, by removing lines", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()

  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)

  fasta_filename <- tempfile(tmpdir = folder_name, fileext = ".fasta")
  topo_filename <- stringr::str_replace(
    string = fasta_filename,
    pattern = ".fasta",
    replacement = ".topo"
  )
  t_fasta <- tibble::tibble(
    name = c("A", "B"),
    sequence = c("FAMI", "LYVW")
  )
  t_topo <- tibble::tibble(
    name = c("A", "B"),
    sequence = c("0000", "")
  )
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_fasta,
    fasta_filename = fasta_filename
  )
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_topo,
    fasta_filename = topo_filename
  )

  expect_true(file.exists(fasta_filename))
  expect_true(file.exists(topo_filename))

  expect_message(
    create_topo_file(
      fasta_filename = fasta_filename,
      verbose = TRUE
    ),
    "Predicting an additional 1 topologies from 2 sequences"
  )

  check_topo_files(topo_filenames = topo_filename)
})

test_that("Continue from some known sequences, by clearing sequences", {
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
  t_topo$sequence[4] <- ""

  # Of the topology, remove the last prediction
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_topo,
    fasta_filename = topo_filename
  )

  expect_message(
    create_topo_file(
      fasta_filename = fasta_filename,
      verbose = TRUE
    ),
    "Predicting an additional 1 topologies from 4 sequences"
  )

  check_topo_files(topo_filenames = topo_filename)
})

test_that("Continue from zero known sequences", {
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  fasta_filename <- tempfile(tmpdir = folder_name, fileext = ".fasta")
  topo_filename <- stringr::str_replace(
    string = fasta_filename,
    pattern = ".fasta",
    replacement = ".topo"
  )

  # Of the FASTA file, only have two predictions
  t_fasta <- tibble::tibble(
    name = c("A", "B"),
    sequence = c("FAMI", "LYVW")
  )
  # Of the topology, remove all predictions
  t_topo <- tibble::tibble(
    name = character(0),
    sequence = character(0)
  )
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_fasta,
    fasta_filename = fasta_filename
  )
  pureseqtmr::save_tibble_as_fasta_file(
    t = t_topo,
    fasta_filename = topo_filename
  )

  expect_true(file.exists(fasta_filename))
  expect_true(file.exists(topo_filename))


  expect_message(
    create_topo_file(
      fasta_filename = fasta_filename,
      verbose = TRUE
    ),
    "Predicting an additional 2 topologies from 2 sequences"
  )
})

test_that("Script crash", {
  skip("Local only")
  if (!pureseqtmr::is_pureseqtm_installed()) return()
  scripts_path <- "~/GitHubs/ncbi_peregrine/scripts"
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  fasta_filename <- file.path(folder_name, "100505989.fasta")
  file.copy(
    from = file.path(scripts_path, "100505989.fasta"),
    to = fasta_filename
  )
  expect_true(file.exists(fasta_filename))
  topo_filename <- file.path(dirname(fasta_filename), "100505989.topo")
  file.copy(
    from = file.path(scripts_path, "100505989.topo"),
    to = topo_filename
  )
  expect_true(file.exists(fasta_filename))

  create_topo_file(
    fasta_filename = fasta_filename
  )
})
