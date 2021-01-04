#' Check all the files in a folder
#' @return names of files that are invalid
#' @export
check_files <- function(folder_name) {

  # gene_ids.csv
  testthat::expect_silent(
    ncbiperegrine::read_genes_ids_file(
      gene_ids_filename = file.path(folder_name, "gene_ids.csv")
    )
  )
  # gene_names.csv
  testthat::expect_silent(
    ncbiperegrine::read_gene_names_file(
      gene_names_filename = file.path(folder_name, "gene_names.csv")
    )
  )
  # [gene_name]_snps.csv
  testthat::expect_silent(
    ncbiperegrine::read_snps_files(
      snps_filenames = list.files(
        folder_name, pattern = "_snps\\.csv$", full.names = TRUE
      )
    )
  )

  # [gene_name]_variations.rds
  # ???

  # [gene_name]_variations.csv
  testthat::expect_silent(
    ncbiperegrine::read_variations_csv_files(
      variations_csv_filenames = list.files(
        folder_name, pattern = "_variations\\.csv$", full.names = TRUE
      )
    )
  )

  # [gene_name].fasta
  # [gene_name].topo
  # [gene_name]_is_in_tmh.csv
}
