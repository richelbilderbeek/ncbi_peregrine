# 1. Create the gene IDs
n_gene_ids <- Inf
if (!peregrine::is_on_peregrine()) {
  n_gene_ids <- 3
}

ncbiperegrine::create_gene_ids(
  n_gene_ids = n_gene_ids,
  filename = "gene_ids.csv"
)
