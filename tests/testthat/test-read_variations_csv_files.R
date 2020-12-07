test_that("use", {
  variations_csv_filenames <- system.file(
    "extdata",
    c("1956_variations.csv", "7124_variations.csv", "348_variations.csv"),
    package = "ncbiperegrine"
  )
  t_variations <- read_variations_csv_files(
    variations_csv_filenames = variations_csv_filenames
  )
  expect_true(tibble::is_tibble(t_variations))
  expect_equal(names(t_variations), c("gene_id", "snp_id", "variation"))
  expect_equal(nrow(t_variations), 80)

  # All gene IDs have a variation
  gene_ids <- as.numeric(
    basename(
      stringr::str_replace(
        string = variations_csv_filenames,
        pattern = "_variations.csv",
        replacement = ""
      )
    )
  )
  expect_true(all(gene_ids %in% t_variations$gene_id))
})
