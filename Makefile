all: create_gene_name_snps_is_done.txt

gene_ids.csv:
	Rscript create_gene_ids.R

gene_names.csv: gene_ids.csv
	Rscript create_gene_names.R

create_gene_name_snps_is_done.txt: gene_names.csv
	Rscript create_gene_name_snps.R

