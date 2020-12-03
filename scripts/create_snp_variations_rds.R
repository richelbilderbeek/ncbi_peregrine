ncbiperegrine::create_snp_variations_rds_files(
  snps_filenames = list.files(pattern = "_snps\\.csv"),
  n_snps = 30
)

readr::write_lines(
  x = Sys.time(),
  file = "create_snp_variations_rds_is_done.txt"
)
