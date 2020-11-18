t <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)
testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$filename <- paste0(t$gene_id, "_variations.csv")

if (!all(file.exists(t$filename))) {
  if (file.exists("create_snp_variations_is_done.txt")) {
    file.remove("create_snp_variations_is_done.txt")
  }
}

# Per gene name, read its SNPs and save the variations
for (i in seq_len(nrow(t))) {
  filename <- t$filename[i] # To save the variations to
  if (file.exists(filename)) next
  gene_name <- t$gene_name[i]
  filename <- t$filename[i] # To save the variations to
  snps_filename <- stringr::str_replace(t$filename[i], pattern = "_variations", replacement = "_snps")
  testthat::expect_true(file.exists(snps_filename))
  t_snp_ids <- readr::read_csv(
    snps_filename,
    col_types = readr::cols(
      snp_id = readr::col_double()
    )
  )

  tibbles <- list()
  for (j in seq_len(nrow(t_snp_ids))) {
    snp_id <- t_snp_ids$snp_id[j]
    variations <- ncbi::get_snp_variations_in_protein_from_snp_id(snp_id)
    tibbles[[j]] <- tibble::tibble(
      snp_id = snp_id,
      variation = variations,
    )
  }

  t_here <- dplyr::bind_rows(tibbles)
  testthat::expect_true("snp_id" %in% names(t_here))
  testthat::expect_true("variation" %in% names(t_here))
  readr::write_csv(x = t_here, file = filename)
  testthat::expect_true(file.exists(filename))
}

readr::write_lines(
  x = Sys.time(),
  file = "create_snp_variations_is_done.txt"
)
