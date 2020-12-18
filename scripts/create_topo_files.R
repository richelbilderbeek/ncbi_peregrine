ncbiperegrine::create_topo_files(
  fasta_filenames = list.files(pattern = "\\.fasta"),
  verbose = TRUE
)

readr::write_lines(
  x = Sys.time(),
  file = "create_topo_files_is_done.txt"
)
