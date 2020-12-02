# Get all human protein gene IDs
all_gene_ids <- ncbi::get_all_human_membrane_protein_gene_ids()

# On Peregrine, use all genes
# On local, use only a few
gene_ids <- all_gene_ids
if (!peregrine::is_on_peregrine()) {
  gene_ids <- head(gene_ids, n = 3)
}

t <- tibble::tibble(
  gene_id = gene_ids
)


readr::write_csv(x = t, file = "gene_ids.csv")
