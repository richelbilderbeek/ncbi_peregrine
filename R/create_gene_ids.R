#' Create all gene IDs of human membrane proteins
#' @inheritParams default_params_doc
#' @export
create_gene_ids <- function(
  n_gene_ids,
  gene_ids_filename
) {
  # Get all human protein gene IDs
  all_gene_ids <- ncbi::get_all_human_membrane_protein_gene_ids()

  # On Peregrine, use all genes
  # On local, use only a few
  gene_ids <- all_gene_ids
  if (is.finite(n_gene_ids)) {
    gene_ids <- utils::head(gene_ids, n = n_gene_ids)
  }

  t_gene_ids <- tibble::tibble(
    gene_id = gene_ids
  )

  readr::write_csv(
    x = t_gene_ids,
    file = gene_ids_filename
  )
}
