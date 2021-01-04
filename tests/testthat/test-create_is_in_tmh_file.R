test_that("use", {
  variations_csv_filename <- tempfile(fileext = "_variations.csv")
  file.copy(
    from = system.file(
      "extdata",
      "1956_variations.csv",
      package = "ncbiperegrine"
    ),
    to = variations_csv_filename
  )
  topo_filename <- tempfile(fileext = ".topo")
  file.copy(
    from = system.file(
      "extdata",
      "1956.topo",
      package = "ncbiperegrine"
    ),
    to = topo_filename
  )
  expect_true(file.exists(variations_csv_filename))
  expect_true(file.exists(topo_filename))
  in_tmh_filename <- create_is_in_tmh_file(
    variations_csv_filename = variations_csv_filename,
    topo_filename = topo_filename
  )
  expect_true(file.exists(in_tmh_filename))
  t_in_tmh <- read_is_in_tmh_file(in_tmh_filename)
  t_variations <- read_variations_csv_file(variations_csv_filename)

  # 'variation' columns must match
  expect_equal(t_variations$variation, t_in_tmh$variation)
})

test_that("use", {
  skip("https://github.com/richelbilderbeek/bbbq_article/issues/134")
  # HIERO
  scripts_path <- "~/GitHubs/ncbi_peregrine/scripts"
  folder_name <- tempfile()
  dir.create(folder_name, showWarnings = FALSE, recursive = TRUE)
  gene_id <- "3269"
  variations_csv_filename <- file.path(
    folder_name,
    paste0(gene_id, "_is_in_tmh.csv")
  )

  expect_silent(
    read_variations_csv_file(
      file.path(scripts_path, basename(variations_csv_filename))
    )
  )

  file.copy(
    from = file.path(scripts_path, basename(variations_csv_filename)),
    to = variations_csv_filename
  )
  topo_filename <- file.path(folder_name, paste0(gene_id, ".topo"))
  file.copy(
    from = file.path(scripts_path, basename(topo_filename)),
    to = topo_filename
  )
  expect_true(file.exists(variations_csv_filename))
  expect_true(file.exists(topo_filename))
  in_tmh_filename <- create_is_in_tmh_file(
    variations_csv_filename = variations_csv_filename,
    topo_filename = topo_filename
  )
  expect_true(file.exists(in_tmh_filename))
  t_in_tmh <- read_is_in_tmh_file(in_tmh_filename)
  t_variations <- read_variations_csv_file(variations_csv_filename)

  # 'variation' columns must match
  expect_equal(t_variations$variation, t_in_tmh$variation)
})
