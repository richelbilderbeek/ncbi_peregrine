ncbiperegrine::create_is_in_tmh_files(
  variations_csv_filenames = list.files(pattern = "_variations\\.csv"),
  topo_filenames = list.files(pattern = "\\.topo")
)

readr::write_lines(
  x = Sys.time(),
  file = "create_is_in_tmh_files_is_done.txt"
)
