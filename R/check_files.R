#' Check all the files in a folder
#' @inheritParams default_params_doc
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
  testthat::expect_silent(
    ncbiperegrine::read_variations_rds_files(
      variations_rds_filenames = list.files(
        folder_name, pattern = "_variations\\.rds$", full.names = TRUE
      )
    )
  )

  # [gene_name]_variations.csv
  testthat::expect_silent(
    ncbiperegrine::read_variations_csv_files(
      variations_csv_filenames = list.files(
        folder_name, pattern = "_variations\\.csv$", full.names = TRUE
      )
    )
  )

  # [gene_name].fasta
  fasta_filenames <- list.files(
    folder_name, pattern = "\\.fasta$", full.names = TRUE
  )
  for (fasta_filename in fasta_filenames) {
    testthat::expect_silent(
      pureseqtmr::load_fasta_file_as_tibble(fasta_filename)
    )
  }

  # [gene_name].topo
  topo_filenames <- list.files(
    folder_name, pattern = "\\.topo$", full.names = TRUE
  )
  ncbiperegrine::check_topo_files(topo_filenames)

  # [gene_name]_is_in_tmh.csv
  is_in_tmh_filenames <- list.files(
    folder_name, pattern = "_is_in_tmh\\.csv$", full.names = TRUE
  )
  for (is_in_tmh_filename in is_in_tmh_filenames) {
    tryCatch({
    testthat::expect_silent(
      ncbiperegrine::read_is_in_tmh_file(
        is_in_tmh_filename
      )
    )
    }, error = function(e) {
      stop("File ", is_in_tmh_filename, " is invalid")
    }
    )
  }

  # results.csv
  testthat::expect_silent(
    ncbiperegrine::read_results_file(
      results_filename = file.path(folder_name, "results.csv")
    )
  )

}
