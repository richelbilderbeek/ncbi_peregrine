t <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)
testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$filename <- paste0(t$gene_id, "_variations.rds")

# Create all files with an empty list
for (i in seq_len(nrow(t))) {

  filename <- t$filename[i] # To save the variations to
  if (!file.exists(filename)) {
    saveRDS(object = list(), file = filename)
  }
}

# Per gene name, read its SNPs and save the variations
for (i in seq_len(nrow(t))) {
  message("i: ", i)

  # The gene
  gene_name <- t$gene_name[i]
  message("gene_name: ", gene_name)

  # The SNPs working on that gene that we already know
  snps_filename <- stringr::str_replace(t$filename[i], pattern = "_variations\\.rds", replacement = "_snps.csv")
  testthat::expect_true(file.exists(snps_filename))
  t_snp_ids <- readr::read_csv(
    snps_filename,
    col_types = readr::cols(
      snp_id = readr::col_double()
    )
  )

  # The variations we're about to obtain
  rds_filename <- t$filename[i] # To save the variations to, may be half done
  testthat::expect_true(file.exists(rds_filename))
  tibbles <- readRDS(rds_filename)
  if (length(tibbles) == nrow(t_snp_ids) &&
      tibble::is_tibble(tail(tibbles, n = 1))) {
    message("Already done with all this gene's SNPs")
    next
  }

  # Per SNP, obtain the variation
  # Save to file after each SNP
  for (j in seq_len(nrow(t_snp_ids))) {
    message("j: ", j)
    snp_id <- t_snp_ids$snp_id[j]
    message("snp_id: ", snp_id)
    variations <- ncbi::get_snp_variations_in_protein_from_snp_id(snp_id)
    tibbles[[j]] <- tibble::tibble(
      snp_id = snp_id,
      variation = variations,
    )
    saveRDS(object = tibbles, file = rds_filename)
  }
}

readr::write_lines(
  x = Sys.time(),
  file = "create_snp_variations_rds_is_done.txt"
)
