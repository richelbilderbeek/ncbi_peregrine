t <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)
testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$rds_filename <- paste0(t$gene_id, "_variations.rds")
t$csv_filename <- paste0(t$gene_id, "_variations.csv")

for (i in seq_len(nrow(t))) {

  # The gene
  gene_name <- t$gene_name[i]
  message(i, "/", nrow(t), ": ", gene_name)

  # The RDS filename
  rds_filename <- t$rds_filename[i]
  testthat::expect_true(file.exists(rds_filename))

  readr::write_csv(
    x = dplyr::bind_rows(readRDS(rds_filename)),
    file = t$csv_filename[i]
  )
}

readr::write_lines(
  x = Sys.time(),
  file = "create_snp_variations_csv_is_done.txt"
)
