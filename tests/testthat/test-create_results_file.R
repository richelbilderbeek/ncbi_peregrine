test_that("use", {
  skip("WIP")
  gene_names_filename <- system.file(
    "extdata", "gene_names.csv",
    package = "ncbiperegrine"
  )
  snp_ids_filenames <- system.file(
    "extdata",
    c("1956_snps.csv", "7124_snps.csv", "348_snps.csv"),
    package = "ncbiperegrine"
  )
  variations_csv_filenames <- system.file(
    "extdata",
    c("1956_variations.csv", "7124_variations.csv", "348_variations.csv"),
    package = "ncbiperegrine"
  )
  is_in_tmh_filenames <- system.file(
    "extdata",
    c("1956_is_in_tmh.csv", "7124_is_in_tmh.csv", "348_is_in_tmh.csv"),
    package = "ncbiperegrine"
  )

  expect_true(file.exists(gene_names_filename))
  expect_true(all(file.exists(snp_ids_filenames)))
  expect_true(all(file.exists(variations_csv_filenames)))
  expect_true(all(file.exists(is_in_tmh_filenames)))

  expect_equal(length(snp_ids_filenames), length(variations_csv_filenames))
  expect_equal(length(snp_ids_filenames), length(is_in_tmh_filenames))

  results_filename <- create_results_file(
    gene_names_filename = gene_names_filename,
    snp_ids_filenames = snp_ids_filenames,
    variations_csv_filenames = variations_csv_filenames,
    is_in_tmh_filenames = is_in_tmh_filenames
  )
  expect_true(file.exists(results_filename))
})
