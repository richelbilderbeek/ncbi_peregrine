ncbiperegrine::create_gene_name_snps(
  gene_names_filename = "gene_names.csv",
  folder_name = getwd()
)

readr::write_lines(
  x = Sys.time(),
  file = "create_gene_name_snps_is_done.txt"
)
