ncbiperegrine::create_snp_variations_csv_files(
  variations_rds_filenames = list.files(pattern = "_variations\\.rds"),
)

readr::write_lines(
  x = Sys.time(),
  file = "create_snp_variations_csv_is_done.txt"
)
