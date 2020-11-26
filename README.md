# ncbi_peregrine

Experiment

  1. Collect 1123 membrane proteins' gene IDs
  2. Convert all 1123 gene IDs to gene names
  3. Per gene name, find the SNP IDs
  4. Per SNP ID, get the variation (in HGVS format)
  5. Per variation that changes the protein structure, score the topology


Gene ID|Gene name|SNP ID    |variation              |is_in_tmh
-------|---------|----------|-----------------------|---------
7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE
.      |.        |Another   |NP_000585.2:p.Gly144Asp|FALSE

## Files

### Input files

None

### Intermediate files

#### :heavy_check_mark: `gene_ids.csv`

 * 1 gene IDs file: `gene_ids.csv`, 
   created by `create_gene_ids.R`,
   a tibble with one column `gene_id`

```
gene_id
-------
1956
7124
348
7040
3091
3586
```

#### :heavy_check_mark: `gene_names.csv`

1 gene IDs file: `gene_names.csv`, 
created by `create_gene_names.R`,
a tibble with two columns `gene_id` and `gene_name`

gene_id|gene_name
-------|----------
1956   |EGFR
7124   |TNF
348    |APOE  
7040   |TGFB1
3091   |HIF1A
3586   |IL10

#### :heavy_check_mark: `[gene_name]_snps.csv`

per gene name, a file named `[gene_name]_snps.csv`,
created by `create_gene_name_snps.R`,
each a tibble with one column `snp_id`.

When all `[gene_name]_snps.csv` files are created,
the file `create_gene_name_snps_is_done.txt`


```
snp_id    
----------
1583049783
...       
```

#### :white_check_mark: `[gene_name]_variations.rds`

Per `[gene_name]_snps.csv`, a file named `[gene_name]_variations.rds`,
created by `create_snp_variations_rds.R`,
each list of tibbles with two columns: `snp_id` and `variation`.
Each tibble can have zero to dozens of rows.

When all `[gene_name]_variation.csv` files are created,
the file `create_snp_variations_rds_is_done.txt`

```
[[1]]
# A tibble: 0 x 2
# ... with 2 variables: snp_id <dbl>, variation <chr>

[[2]]
# A tibble: 1 x 2
      snp_id variation              
       <dbl> <chr>                  
1 1599031008 NP_001156469.1:p.Val35=

[[4]]
# A tibble: 2 x 2
      snp_id variation                
       <dbl> <chr>                    
1 1599030856 NP_001156469.1:p.Trp20Arg
2 1599030856 NP_001156469.1:p.Trp20Cys

[[15]]
# A tibble: 0 x 2
# ... with 2 variables: snp_id <dbl>, variation <chr>
```

#### :heavy_check_mark: `[gene_name]_variations.csv`

Per `[gene_name]_variations.rds`, a file named `[gene_name]_variations.csv`,
created by `create_snp_variations_csv.R`,
each a tibble with two columns: `snp_id` and `variation`.

When all `[gene_name]_variation.csv` files are created,
the file `create_snp_variations_csv_is_done.txt`

snp_id    |variation              
----------|-----------------------
1583049783|NP_000585.2:p.Gly144Asp
...       |...                    

#### `[gene_name].fasta`

The script `create_fasta_files.R`,
per gene name, reads the `[gene_name]_variation.csv` file,
and creates a file `[gene_name].fasta` with all the variation'
proteins' sequences.

When all `[gene_name].fasta` files are created,
the file `create_fasta_files_is_done.txt`

```
> NP_001007554.1
FANTASTICALLY
> NP_001229821.1
FAMILYVW
```

For example, `https://www.ncbi.nlm.nih.gov/snp/rs1570884790` is a SNP that
works on multiple proteins:

```
NP_001007554.1:p.Val754Gly
NP_001229821.1:p.Val754Gly
NP_009089.4:p.Val723Gly
NP_001229822.1:p.Val723Gly
NP_001123995.1:p.Val769Gly
NP_001229820.1:p.Val800Gly 
```

#### `[gene_name].topo`

The script `create_topo_files.R`,
per gene name, reads the `[gene_name].fasta` file,
and creates a file `[gene_name].topo` with the topology 
of these proteins.

When all `[gene_name].topo` files are created,
the file `create_topo_files_is_done.txt`

```
> NP_001007554.1
0000000110000
> NP_001229821.1
0000000000000
```

#### :white_check_mark: `[gene_name]_is_in_tmh.csv`

Per gene name, reads the `[gene_name]_variation.csv` 
and `[gene_name].topo` file. 
For each variation, it tallies if the variation is in a TMH,
as well as the proportion of TMH in the protein. 
done by script `create_is_in_tmh_files.R`

variation              |is_in_tmh|p_in_tmh
-----------------------|---------|--------
NP_000585.2:p.Gly144Asp|FALSE    |0.123   

### Results files

 * All raw output files in one table, `results.csv`,
   created by `create_results.sh`

gene_id|gene_name|snp_id    |variation              |is_in_tmh|p_in_tmh
-------|---------|----------|-----------------------|---------|--------
7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.123
...    |...      |...       |...                    |...      |...

## Estimated time

 * 8 seconds per gene ID, 
 * Must be done in sequence for NCBI
 * 8 seconds * 1123 jobs = 9000 secs = 150 mins = 3 hours
 

