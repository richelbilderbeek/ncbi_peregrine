# ncbi_peregrine

Branch   |[GitHub Actions](https://github.com/richelbilderbeek/ncbi_peregrine/actions)                                     |[![Codecov logo](man/figures/Codecov.png)](https://www.codecov.io)
---------|-----------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
`master` |![R-CMD-check](https://github.com/richelbilderbeek/ncbi_peregrine/workflows/R-CMD-check/badge.svg?branch=master) |[![codecov.io](https://codecov.io/github/richelbilderbeek/ncbi_peregrine/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/ncbi_peregrine/branch/master)
`develop`|![R-CMD-check](https://github.com/richelbilderbeek/ncbi_peregrine/workflows/R-CMD-check/badge.svg?branch=develop)|[![codecov.io](https://codecov.io/github/richelbilderbeek/ncbi_peregrine/coverage.svg?branch=develop)](https://codecov.io/github/richelbilderbeek/ncbi_peregrine/branch/develop)

Experiment

  1. Collect 1123 membrane proteins' gene IDs
  2. Convert all 1123 gene IDs to gene names
  3. Per gene name, find the SNP IDs
  4. Per SNP ID, get the variation (in HGVS format)
  5. Per variation that changes the protein structure, score the topology


Gene ID|Gene name|SNP ID    |variation              |is_in_tmh|p_is_tmh
-------|---------|----------|-----------------------|---------|--------
7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.1
.      |.        |Another   |NP_000585.2:p.Gly144Asp|FALSE    |0.2

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

gene_id|gene_name|snp_id    |variation              |is_in_tmh|p_in_tmh|n_tmh
-------|---------|----------|-----------------------|---------|--------|-----
7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.123   |314
...    |...      |...       |...                    |...      |...     |271


```
|----------------|
  gene_names.csv

                 |----------|
                 [gene_name]_snps.csv

                 |----------------------------------|
                      [gene_name]_variations.csv

                            |------------------------------------------|
                                     [gene_name]_is_in_tmh.csv

                            |-----------------------|                  |-----|
                                                      [gene_name].topo
```

## Estimated time

 * 8 seconds per gene ID, 
 * Must be done in sequence for NCBI
 * 8 seconds * 1123 jobs = 9000 secs = 150 mins = 3 hours

In reality:

```
real	63m32.145s
user	49m42.254s
sys	0m31.846s
```

```
real	61m2.904s
user	44m32.908s
sys	0m28.639s
``` 

```
real	63m14.851s
user	47m47.423s
sys	0m32.378s
```

```
real	63m25.927s
user	45m41.377s
sys	0m29.540s
```

## How are the figures created?

By running the tests of `ncbi_results` locally.

## Downloads

 * 30 SNPs per gene ID: [ncbi_peregrine_data_20201214.zip](http://richelbilderbeek.nl/ncbi_peregrine_data_20201214.zip)
 * 60 SNPs per gene ID: [ncbi_peregrine_data_20201219.zip](http://richelbilderbeek.nl/ncbi_peregrine_data_20201219.zip)

