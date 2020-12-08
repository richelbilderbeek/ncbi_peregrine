args <- commandArgs(trailingOnly = TRUE)
testthat::expect_equal(1, length(args))
n_snps <- as.numeric(args[1])
message("n_snps: ", n_snps)

ncbiperegrine::create_snp_variations_rds_files(
  snps_filenames = list.files(pattern = "_snps\\.csv"),
  n_snps = n_snps
)

readr::write_lines(
  x = Sys.time(),
  file = "create_snp_variations_rds_is_done.txt"
)
