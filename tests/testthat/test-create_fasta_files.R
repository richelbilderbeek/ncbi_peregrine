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
  source_variations_csv_filenames <- system.file(
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
    "Skip creating '.*.fasta': it is already present"
  )

  # 2nd FASTA file is created
  expect_equal(
    2,
    length(list.files(path = folder, pattern = ".fasta"))
  )
})
