ncbiperegrine::create_snp_variations_rds(
  gene_names_filename = "gene_names.csv"
)

readr::write_lines(
  x = Sys.time(),
  file = "create_snp_variations_rds_is_done.txt"
)
