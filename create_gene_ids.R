# Get all human protein gene IDs
all_gene_ids <- ncbi::get_all_human_membrane_protein_gene_ids()

t <- tibble::tibble(
  gene_id = all_gene_ids
)

readr::write_csv(x = t, file = "gene_ids.csv")
