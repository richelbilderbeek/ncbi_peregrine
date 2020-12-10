test_that("use", {
  topo_filenames <- system.file(
    "extdata",
    c("1956.topo", "348.topo"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(topo_filenames)))
  in_tmh_filenames <- create_is_in_tmh_files(
    topo_filenames = topo_filenames
  )
  expect_true(all(file.exists(in_tmh_filenames)))
})

test_that("skip existing is_in_tmh files", {
  skip("WIP")
  # 2 topo files should result in 2 is_in_tmh files
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
