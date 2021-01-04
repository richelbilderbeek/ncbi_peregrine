#' Check all the files in a folder
#' @return names of files that are invalid
#' @export
check_files <- function(folder_name) {
  # gene_ids.csv
  testthat::expect_silent(
    read_genes_ids_file(
      gene_ids_filename = file.path(folder_name, "gene_ids.csv")
    )
  )
  # gene_names.csv

  # [gene_name]_snps.csv
  # [gene_name]_variations.rds
  # [gene_name]_variations.csv
  # [gene_name].fasta
  # [gene_name].topo
  # [gene_name]_is_in_tmh.csv
}
