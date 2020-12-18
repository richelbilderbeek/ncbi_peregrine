test_that("use", {
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  source_variations_csv_filename <- system.file(
    "extdata",
    "1956_variations.csv",
    package = "ncbiperegrine"
  )
  variations_csv_filename <- file.path(
    folder_name,
    basename(source_variations_csv_filename)
  )
  file.copy(
    from = source_variations_csv_filename,
    to = variations_csv_filename
  )
  expect_true(all(file.exists(variations_csv_filename)))
  fasta_filename <- create_fasta_file(
    variations_csv_filename = variations_csv_filename
  )
  expect_true(file.exists(fasta_filename))
  t_variations <- read_variations_csv_file(variations_csv_filename)
  t_sequences <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)

  expect_equal(
    t_sequences$name,
    stringr::str_replace(
      string = t_variations$variation,
      pattern = ":.*",
      replacement = ""
    )
  )
})

test_that("Peregrine crash 2020-12-09", {
  variations_csv_filename <- tempfile(fileext = "_variations.csv")
  file.copy(
    from = system.file(
      "extdata",
      "7216_variations.csv",
      package = "ncbiperegrine"
    ),
    to = variations_csv_filename
  )
  expect_true(all(file.exists(variations_csv_filename)))
  fasta_filename <- create_fasta_file(
    variations_csv_filename = variations_csv_filename
  )
  expect_true(file.exists(fasta_filename))
  t_variations <- read_variations_csv_file(variations_csv_filename)
  t_sequences <- pureseqtmr::load_fasta_file_as_tibble(fasta_filename)

  expect_equal(
    t_sequences$name,
    stringr::str_replace(
      string = t_variations$variation,
      pattern = ":.*",
      replacement = ""
    )
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
    create_fasta_file(
      variations_csv_filename = variations_csv_filename,
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
  fasta_filename <- create_fasta_file(
    variations_csv_filename = variations_csv_filename
  )
  expect_true(file.exists(fasta_filename))

  # Add 1 more variation
  readr::write_csv(x = t_variations[1:3, ], file = variations_csv_filename)
  expect_true(file.exists(variations_csv_filename))
  expect_equal(3, nrow(read_variations_csv_file(variations_csv_filename)))

  # Update the FASTA file
  expect_message(
    fasta_filename <- create_fasta_file(
      variations_csv_filename = variations_csv_filename,
      verbose = TRUE
    ),
    "Fetching 1/3 new protein sequences"
  )
  expect_true(file.exists(fasta_filename))

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
    create_fasta_file(
      variations_csv_filename = variations_csv_filename
    )
  )

  # Create the FASTA file again
  expect_message(
    create_fasta_file(
      variations_csv_filename = variations_csv_filename,
      verbose = TRUE
    ),
    "Already fetched all 2 protein sequences"
  )
})
