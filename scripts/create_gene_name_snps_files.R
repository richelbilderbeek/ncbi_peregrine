ncbiperegrine::create_gene_name_snps_files(
  gene_names_filename = "gene_names.csv"
)

readr::write_lines(
  x = Sys.time(),
  file = "create_gene_name_snps_files_is_done.txt"
)
