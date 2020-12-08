#' Read the SNPs filenames to create one big table from it.
#' To maintain information about the gene name,
#' the gene names table is used to convert a known gene ID to
#' a gene name. Note that things will go fine without the gene
#' names table: the gene name can be deduced later
#' @inheritParams default_params_doc
#' @export
read_snps_files <- function(
  snps_filenames
) {
  testthat::expect_true(all(file.exists(snps_filenames)))
  t_snp_ids <- list()
  n_sps_filenames <- length(snps_filenames)
  for (i in seq_len(n_sps_filenames)) {
    t <- read_snps_file(snps_filenames[i])
    gene_id <- as.numeric(
        basename(
        stringr::str_replace(
          string = snps_filenames[i],
          pattern = "_snps.csv",
          replacement = ""
        )
      )
    )
    t$gene_id <- gene_id

    t_snp_ids[[i]] <- t
  }
  dplyr::select(
    dplyr::bind_rows(t_snp_ids),
    "gene_id", "snp_id"
  )
}
