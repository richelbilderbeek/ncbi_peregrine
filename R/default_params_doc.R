#' This function does nothing. It is intended to inherit is parameters'
#' documentation.
#' @param gene_ids_filename the filename to save
#'   the gene IDs to.
#'   For the experiment, use \code{gene_ids.csv}
#' @param gene_names_filename the filename to save
#'   the gene IDs and gene names to.
#'   For the experiment, use \code{gene_names.csv}
#' @param n_gene_ids the number of gene IDs.
#'   Use \link{Inf} to use all gene IDs
#' @param n_snps the number of SNPs.
#'   Use \link{Inf} to use all SNS IDs
#' @param snps_filename one filenames of a file
#'   containing the SNP IDs,
#'   named \code{[gene_name]_snps.csv}.
#'   These files can be read by \link{read_snps_file}
#' @param snps_filenames one or more filenames of files
#'   containing the SNP IDs,
#'   named \code{[gene_name]_snps.csv}.
#'   These files can be read by \link{read_snps_file}
#' @param variations_csv_filename name of a \code{[gene_name]_variations.csv}
#'   file
#' @param variations_csv_filenames names of one or more
#'   \code{[gene_name]_variations.csv}
#'   files
#' @param variations_rds_filename name of a \code{[gene_name]_variations.rds}
#'   file
#' @param variations_rds_filenames names of one or more
#'   \code{[gene_name]_variations.rds}
#'   files
#' @param verbose set to TRUE for more output
#' @author Richèl J.C. Bilderbeek
#' @note This is an internal function, so it should be marked with
#'   \code{@noRd}. This is not done, as this will disallow all
#'   functions to find the documentation parameters
default_params_doc <- function(
  gene_ids_filename,
  gene_names_filename,
  n_gene_ids,
  n_snps,
  snps_filename,
  snps_filenames,
  variations_csv_filename,
  variations_csv_filenames,
  variations_rds_filename,
  variations_rds_filenames,
  verbose
) {
  # Nothing
}
