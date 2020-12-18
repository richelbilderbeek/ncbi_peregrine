test_that("use", {
  variations_csv_filenames  <- replicate(
    n = 3,
    tempfile(fileext = "_variations.csv")
  )
  file.copy(
    from = system.file(
      "extdata",
      c("1956_variations.csv", "348_variations.csv", "7124_variations.csv"),
      package = "ncbiperegrine"
    ),
    to = variations_csv_filenames
  )

  expect_true(all(file.exists(variations_csv_filenames)))
  fasta_filenames <- create_fasta_files(
    variations_csv_filenames = variations_csv_filenames
  )
  expect_true(all(file.exists(fasta_filenames)))
  expect_equal(
    stringr::str_replace(
      string = variations_csv_filenames,
      pattern = "_variations.csv",
      replacement = ".fasta"
    ),
    fasta_filenames
  )
})

test_that("skip existing FASTA files", {
  # 2 variations files should result in 2 FASTA files
  # In this setup, only the second variations files lacks a FASTA file
  # Creating the first FASTA file should be skipped
  folder <- tempfile()
  dir.create(path = folder, showWarnings = FALSE, recursive = TRUE)

  # Create the variations_csv_filenames in the folder
  source_variations_csv_filenames <- system.file( # nolint indeed a long variable name
      "extdata",
      c("1956_variations.csv", "348_variations.csv"),
      package = "ncbiperegrine"
    )
  variations_csv_filenames <- file.path(
    folder,
    basename(source_variations_csv_filenames)
  )
  file.copy(
    from = source_variations_csv_filenames,
    to = variations_csv_filenames
  )
  expect_equal(2, length(variations_csv_filenames))
  expect_true(all(file.exists(variations_csv_filenames)))

  # Create the FASTA file in the folder
  source_fasta_filenames <- system.file(
      "extdata",
      c("1956.fasta"),
      package = "ncbiperegrine"
    )
  fasta_filenames <- file.path(
    folder,
    basename(source_fasta_filenames)
  )
  file.copy(
    from = source_fasta_filenames,
    to = fasta_filenames
  )
  expect_equal(1, length(fasta_filenames))
  expect_true(all(file.exists(fasta_filenames)))

  # 2nd FASTA file is not yet created
  expect_equal(
    1,
    length(list.files(path = folder, pattern = ".fasta"))
  )

  expect_message(
    create_fasta_files(
      variations_csv_filenames = variations_csv_filenames,
      verbose = TRUE
    ),
    "Already fetched all 4 protein sequences"
  )

  # 2nd FASTA file is created
  expect_equal(
    2,
    length(list.files(path = folder, pattern = ".fasta"))
  )
})

test_that("FASTA file gets skipped if there are no protein sequences", {

  # Copy only 0 variations
  variations_csv_filename <- tempfile(fileext = "_variations.csv")
  t_variations <- read_variations_csv_file(
      system.file("extdata", "7216_variations.csv", package = "ncbiperegrine")
  )
  readr::write_csv(x = t_variations[c(), ], file = variations_csv_filename)
  expect_true(file.exists(variations_csv_filename))
  expect_equal(0, nrow(read_variations_csv_file(variations_csv_filename)))

  # Create the FASTA file again
  expect_message(
    create_fasta_files(
      variations_csv_filenames = variations_csv_filename,
      verbose = TRUE
    ),
    "Zero variations results in zero protein sequences to look up"
  )
})

test_that("FASTA file gets updated with more variants", {

  # Copy only 2 variations
  variations_csv_filename <- tempfile(fileext = "_variations.csv")
  t_variations <- read_variations_csv_file(
      system.file("extdata", "7216_variations.csv", package = "ncbiperegrine")
  )
  readr::write_csv(x = t_variations[1:2, ], file = variations_csv_filename)
  expect_true(file.exists(variations_csv_filename))
  expect_equal(2, nrow(read_variations_csv_file(variations_csv_filename)))

  # Create a FASTA file
  expect_silent(
    create_fasta_files(
      variations_csv_filenames = variations_csv_filename
    )
  )

  # Add 1 more variation
  readr::write_csv(x = t_variations[1:3, ], file = variations_csv_filename)
  expect_true(file.exists(variations_csv_filename))
  expect_equal(3, nrow(read_variations_csv_file(variations_csv_filename)))

  # Update the FASTA file
  expect_message(
    create_fasta_files(
      variations_csv_filenames = variations_csv_filename,
      verbose = TRUE
    ),
    "Fetching 1/3 new protein sequences"
  )
})

test_that("FASTA file gets skipped if all proteins sequences are known", {

  # Copy only 2 variations
  variations_csv_filename <- tempfile(fileext = "_variations.csv")
  t_variations <- read_variations_csv_file(
      system.file("extdata", "7216_variations.csv", package = "ncbiperegrine")
  )
  readr::write_csv(x = t_variations[1:2, ], file = variations_csv_filename)
  expect_true(file.exists(variations_csv_filename))
  expect_equal(2, nrow(read_variations_csv_file(variations_csv_filename)))

  # Create a FASTA file
  expect_silent(
    create_fasta_files(
      variations_csv_filenames = variations_csv_filename
    )
  )

  # Create the FASTA file again
  expect_message(
    create_fasta_files(
      variations_csv_filenames = variations_csv_filename,
      verbose = TRUE
    ),
    "Already fetched all 2 protein sequences"
  )
})
