t <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)

testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$filename <- paste0(t$gene_id, "_snps.csv")
t$n_snps <- NA

if (!all(file.exists(t$filename))) {
  warning("Not all files are done")
}

# Per gene name, save its SNPs
for (i in seq_len(nrow(t))) {
  filename <- t$filename[i]
  t_here <- readr::read_csv(
    filename,
    col_types = readr::cols(snp_id = readr::col_double())
  )
  t$n_snps[i] <- nrow(t_here)
}


max(t$n_snps)
library(dplyr)



ggplot2::ggplot(
  dplyr::filter(t, n_snps != 0),
  ggplot2::aes(x = n_snps)
) + ggplot2::geom_histogram() +
  ggplot2::scale_x_log10(name = "Number of SNPS (zeroes removed)") +
  ggplot2::geom_vline(xintercept = mean(t$n_snps)) +
  ggplot2::labs(
    title = "Number of SNPs per gene",
    caption = paste0(
      "Number of genes: ", nrow(t), "\n",
      "Lowest non-zero number of SNPs per gene: ", min((dplyr::filter(t, n_snps != 0))$n_snps), "\n",
      "Mean number of SNPs per gene: ", mean(t$n_snps), "\n",
      "Total number of SNPs: ", sum(t$n_snps), "\n"
    )
  ) + ggthemes::theme_excel_new(base_size = 24)
