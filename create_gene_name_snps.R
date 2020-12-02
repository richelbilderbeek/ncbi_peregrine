t <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)

testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$snps_filename <- paste0(t$gene_id, "_snps.csv")

# if (!all(file.exists(t$filename))) {
#   if (file.exists("create_gene_name_snps_is_done.txt")) {
#     file.remove("create_gene_name_snps_is_done.txt")
#   }
# }

# Per gene name, save its SNPs
for (i in seq_len(nrow(t))) {
  snps_filename <- t$snps_filename[i]
  if (file.exists(snps_filename)) next
  gene_name <- t$gene_name[i]
  t_here <- tibble::tibble(
    snp_id = ncbi::get_snp_ids_from_gene_name(gene_name)
  )
  testthat::expect_true("snp_id" %in% names(t_here))
  if (nrow(t_here) > 0) {
    readr::write_csv(x = t_here, file = snps_filename)
  } else {
    file.create(filename)
  }
  testthat::expect_true(file.exists(snps_filename))
}

readr::write_lines(
  x = Sys.time(),
  file = "create_gene_name_snps_is_done.txt"
)
