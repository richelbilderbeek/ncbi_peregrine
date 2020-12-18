ncbiperegrine::create_fasta_files(
  variations_csv_filenames = list.files(pattern = "_variations\\.csv"),
  verbose = TRUE
)

readr::write_lines(
  x = Sys.time(),
  file = "create_fasta_files_is_done.txt"
)
