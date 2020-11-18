all: results.csv

gene_ids.csv:
	Rscript create_gene_ids.R

gene_names.csv: gene_ids.csv
	Rscript create_gene_names.R

create_gene_name_snps_is_done.txt: gene_names.csv
	Rscript create_gene_name_snps.R

%results.csv: gene_names.csv
%	% Will create intermediate files as well
%	Rscript create_all_gene_name_snp_id.R
%	Rscript create_all_snp_variations.R
%	Rscript create_results.R

