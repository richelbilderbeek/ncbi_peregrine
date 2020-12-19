test_that("use", {
  # Copy all input files needed to a temp folder
  folder_name <- tempfile()
  dir.create(folder_name, showWarnings = FALSE, recursive = TRUE)
  source_topo_filenames  <- system.file(
    "extdata",
    c("1956.topo", "348.topo"),
    package = "ncbiperegrine"
  )
  source_variations_csv_filenames <- stringr::str_replace( # nolint indeed a long variable name
    string = source_topo_filenames,
    pattern = ".topo",
    replacement = "_variations.csv"
  )
  topo_filenames <- file.path(folder_name, basename(source_topo_filenames))
  variations_csv_filenames <- file.path(
    folder_name, basename(source_variations_csv_filenames))
  file.copy(
    from = source_topo_filenames,
    to = topo_filenames
  )
  file.copy(
    from = source_variations_csv_filenames,
    to = variations_csv_filenames
  )

  # Ready for the real work
  expect_true(all(file.exists(topo_filenames)))
  expect_true(all(file.exists(variations_csv_filenames)))
  in_tmh_filenames <- create_is_in_tmh_files(
    topo_filenames = topo_filenames
  )
  expect_true(all(file.exists(in_tmh_filenames)))
  expect_equal(length(topo_filenames), length(in_tmh_filenames))
})

test_that("skip existing is_in_tmh files", {
  skip("Not now")
  # 2 topo and 2 variations files should result in 2 is_in_tmh files
  # if 1 is_in_tmh file is present, it should be skipped
  # Copy all input files needed to a temp folder
  folder_name <- tempfile()
  dir.create(folder_name, showWarnings = FALSE, recursive = TRUE)
  source_topo_filenames  <- system.file(
    "extdata",
    c("1956.topo", "348.topo"),
    package = "ncbiperegrine"
  )
  source_variations_csv_filenames <- stringr::str_replace( # nolint indeed a long variable name
    string = source_topo_filenames,
    pattern = ".topo",
    replacement = "_variations.csv"
  )
  source_is_in_tmh_filenames <- stringr::str_replace(
    string = source_topo_filenames,
    pattern = ".topo",
    replacement = "_is_in_tmh.csv"
  )[1] # Only copy the first one
  topo_filenames <- file.path(folder_name, basename(source_topo_filenames))
  variations_csv_filenames <- file.path(
    folder_name, basename(source_variations_csv_filenames)
  )
  is_in_tmh_filenames <- file.path(
    folder_name, basename(source_is_in_tmh_filenames)
  )
  file.copy(
    from = source_topo_filenames,
    to = topo_filenames
  )
  file.copy(
    from = source_variations_csv_filenames,
    to = variations_csv_filenames
  )
  file.copy(
    from = source_is_in_tmh_filenames,
    to = is_in_tmh_filenames
  )


  # Ready for the real work
  # 2nd is_in_tmh file is not yet created
  expect_equal(
    1,
    length(list.files(path = folder_name, pattern = "_is_in_tmh.csv"))
  )

  expect_message(
    create_is_in_tmh_files(
      topo_filenames = topo_filenames,
      verbose = TRUE
    ),
    "Skip creating '.*_is_in_tmh.csv': it is already present"
  )

  # 2nd is_in_tmh file is now created
  expect_equal(
    2,
    length(list.files(path = folder_name, pattern = "_is_in_tmh.csv"))
  )
})
