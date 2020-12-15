args <- commandArgs(trailingOnly = TRUE)
testthat::expect_equal(2, length(args))
n_snps <- as.numeric(args[1])
verbose <- as.logical(args[2])
message("n_snps: ", n_snps)
message("verbose: ", verbose)

ncbiperegrine::create_snp_variations_rds_files(
  snps_filenames = list.files(pattern = "_snps\\.csv"),
  n_snps = n_snps,
  verbose = verbose
)

readr::write_lines(
  x = Sys.time(),
  file = "create_snp_variations_rds_is_done.txt"
)
