all: create_snp_variations_csv_is_done.txt

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

clean:
	rm *.csv *.txt *.rds
