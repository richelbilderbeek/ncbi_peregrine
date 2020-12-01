all: results.csv

gene_ids.csv:
	Rscript create_gene_ids.R

gene_names.csv: gene_ids.csv
	Rscript create_gene_names.R

create_gene_name_snps_is_done.txt: gene_names.csv
	Rscript create_gene_name_snps.R

create_snp_variations_rds_is_done.txt: create_gene_name_snps_is_done.txt
	Rscript create_snp_variations_rds.R

# Create the CSVs after all SNPs are saved as .rds
# Can also be run by hand
create_snp_variations_csv_is_done.txt: create_snp_variations_rds_is_done.txt
	Rscript create_snp_variations_csv.R

create_fasta_files_is_done.txt: create_snp_variations_csv_is_done.txt
	Rscript create_fasta_files.R

create_topo_files_is_done.txt: create_fasta_files_is_done.txt
	Rscript create_topo_files.R

create_is_in_tmh_files_is_done.txt: create_topo_files_is_done.txt
	Rscript create_is_in_tmh_files.R

results.csv: create_is_in_tmh_files_is_done.txt
	Rscript create_results.R

clean:
	rm *.csv *.txt *.rds
