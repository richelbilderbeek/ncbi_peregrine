# Get all human protein gene IDs
all_gene_ids <- ncbi::get_all_human_membrane_protein_gene_ids()

n_gene_ids <- 3

t <- tibble::tibble(
  gene_id = head(all_gene_ids, n = n_gene_ids)
)
t
readr::write_csv(x = t, file = "gene_ids.csv")
