test_that("use", {
  snps_filename <- tempfile(fileext = "_snps.csv")
  file.copy(
    from = system.file("extdata", "7124_snps.csv", package = "ncbiperegrine"),
    to = snps_filename
  )
  n_snps <- 10
  expect_true(file.exists(snps_filename))
  readLines(snps_filename)
  variations_rds_filename <- create_snp_variations_rds_file(
    snps_filename = snps_filename,
    n_snps = n_snps
  )
  expect_true(file.exists(variations_rds_filename))
  tibbles <- read_variations_rds_file(
    variations_rds_filename = variations_rds_filename
  )

  expect_equal(length(tibbles), n_snps)
  expect_equal(1, nrow(tibbles[[7]]))
  expect_equal(
    tibbles[[7]]$snp_id,
    read_snps_file(snps_filename = snps_filename)$snp_id[7]
  )
})


test_that("continue", {
  # If the target RDS file has processed some (but not all) SNPs,
  # skip those SNPSs
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  snps_filename <- file.path(folder_name, "7124_snps.csv")
  file.copy(
    from = system.file("extdata", "7124_snps.csv", package = "ncbiperegrine"),
    to = snps_filename
  )
  variations_rds_filename <- file.path(folder_name, "7124_variations.rds")
  file.copy(
    from = system.file(
      "extdata", "7124_variations.rds", package = "ncbiperegrine"
    ),
    to = variations_rds_filename
  )
  expect_true(file.exists(snps_filename))
  expect_true(file.exists(variations_rds_filename))

  n_sps_done <- length(read_variations_rds_file(variations_rds_filename))
  n_snps <- n_sps_done + 1
  expect_message(
    create_snp_variations_rds_file(
      snps_filename = snps_filename,
      n_snps = n_snps,
      verbose = TRUE
    ),
    "SNP 30/31: already done"
  )
  expect_true(file.exists(variations_rds_filename))
  expect_equal(
    n_snps,
    length(read_variations_rds_file(variations_rds_filename))
  )
})

test_that("done all", {
  # If the target RDS file has processed all SNPs,
  # skip all SNPSs
  folder_name <- tempfile()
  dir.create(path = folder_name, showWarnings = FALSE, recursive = TRUE)
  snps_filename <- file.path(folder_name, "7124_snps.csv")
  file.copy(
    from = system.file("extdata", "7124_snps.csv", package = "ncbiperegrine"),
    to = snps_filename
  )
  variations_rds_filename <- file.path(folder_name, "7124_variations.rds")
  file.copy(
    from = system.file(
      "extdata", "7124_variations.rds", package = "ncbiperegrine"
    ),
    to = variations_rds_filename
  )
  expect_true(file.exists(snps_filename))
  expect_true(file.exists(variations_rds_filename))

  n_sps_done <- length(read_variations_rds_file(variations_rds_filename))
  n_snps <- 1 # All done :-)
  expect_message(
    create_snp_variations_rds_file(
      snps_filename = snps_filename,
      n_snps = n_snps,
      verbose = TRUE
    ),
    "Already processed 30 out of 1 SNPs"
  )
  expect_true(file.exists(variations_rds_filename))
  expect_true(
    length(
      read_variations_rds_file(
        variations_rds_filename = variations_rds_filename
      )
    ) > n_snps
  )
})
