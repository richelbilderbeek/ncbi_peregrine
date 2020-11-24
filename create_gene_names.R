gene_ids <- readr::read_csv(
  "gene_ids.csv",
  col_types = readr::cols(
    gene_id = readr::col_double()
  )
)

t <- tibble::tibble(
  gene_id = gene_ids$gene_id,
  gene_name = NA
)

# Do this per 100
sample_size <- 100
while (sum(is.na(t$gene_name)) > sample_size) {
  indices <- sample(which(is.na(t$gene_name)), size = sample_size, replace = FALSE)
  testthat::expect_equal(sample_size, length(indices))
  testthat::expect_true(all( is.na(t$gene_name[indices])))
  gene_ids <- t$gene_id[indices]
  testthat::expect_equal(length(indices), length(gene_ids))
  gene_names <- ncbi::get_gene_names_from_human_gene_ids(gene_ids)
  t$gene_name[indices] <- gene_names
  testthat::expect_true(all(!is.na(t$gene_name[indices])))
  Sys.sleep(0.51)
}

indices <- which(is.na(t$gene_name))
testthat::expect_true(length(indices) < sample_size)
testthat::expect_true(all(is.na(t$gene_name[indices])))
gene_ids <- t$gene_id[indices]
testthat::expect_equal(length(indices), length(gene_ids))
gene_names <- ncbi::get_gene_names_from_human_gene_ids(gene_ids)
t$gene_name[indices] <- gene_names
testthat::expect_true(all(!is.na(t$gene_name[indices])))
Sys.sleep(0.51)

readr::write_csv(x = t, file = "gene_names.csv")
