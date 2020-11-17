all: gene_ids.csv

gene_ids.csv:
	Rscript create_gene_ids.R
