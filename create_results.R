t <- readr::read_csv("gene_names.csv")

testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$filename <- paste0(t$gene_id, ".csv")

# Most of the work is here
while (sum(!file.exists(t$filename)) > 0) {
  index <- sample(which(!file.exists(t$filename)), size = 1)
  filename <- t$filename[index]
  testthat::expect_false(file.exists(filename))
  gene_name <- t$gene_name[index]
  gene_name <- t$gene_name[index]
  t_here <- ncbi::get_gene_name_snp_variation_topology(gene_name)
  testthat::expect_true("snp_id" %in% names(t_here))
  testthat::expect_true("variation" %in% names(t_here))
  testthat::expect_true("is_in_tmh" %in% names(t_here))
  readr::write_csv(x = t_here, file = filename)
  testthat::expect_true(file.exists(filename))
}

print("Time to actually combine the results :-)")
