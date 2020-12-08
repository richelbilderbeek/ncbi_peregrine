test_that("use", {
  snps_filenames <- system.file(
    "extdata",
    c("1956_snps.csv", "7124_snps.csv", "348_snps.csv"),
    package = "ncbiperegrine"
  )
  expect_true(all(file.exists(snps_filenames)))
  t_snpses <- read_snps_files(
    snps_filenames = snps_filenames
  )
  expect_true(tibble::is_tibble(t_snpses))
  expect_equal(c("gene_id", "snp_id"), names(t_snpses))

  gene_ids <- basename(
    stringr::str_replace(
      string = snps_filenames,
      pattern = "_snps.csv",
      replacement = ""
    )
  )
  # All gene names have at least one SNP)
  expect_true(all(gene_ids %in% t_snpses$gene_id))
  expect_equal(nrow(t_snpses), 52093)
})
