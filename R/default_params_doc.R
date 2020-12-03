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
#' @param verbose set to TRUE for more output
#' @author Richèl J.C. Bilderbeek
#' @note This is an internal function, so it should be marked with
#'   \code{@noRd}. This is not done, as this will disallow all
#'   functions to find the documentation parameters
default_params_doc <- function(
  gene_ids_filename,
  gene_names_filename,
  n_gene_ids,
  verbose
) {
  # Nothing
}
