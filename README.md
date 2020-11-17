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

 * 1 gene IDs file: `gene_ids.csv`, 
   created by `create_gene_ids.sh`,
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

 * 1 gene IDs file: `gene_names.csv`, 
   created by `create_gene_names.sh`,
   a tibble with two columns `gene_id` and `gene_name`

gene_id|gene_name
-------|----------
1956   |EGFR
7124   |TNF
348    |APOE  
7040   |TGFB1
3091   |HIF1A
3586   |IL10

### Raw output files

 * 1123 gene ID results file, e.g. `7124.csv`, 
   created on a per-job basis by `create_gene_id_results.sh 7124`,
   a tibble with column names `gene_id` (equals the filename),
   `gene_name` (all values identical), `snp_id`, `variation`, `is_in_tmh`

snp_id    |variation              |is_in_tmh
----------|-----------------------|---------
1583049783|NP_000585.2:p.Gly144Asp|FALSE
...       |...                    |...

### Results files

 * All raw output files in one table, `results.csv`,
   created by `create_results.sh`

gene_id|gene_name|snp_id    |variation              |is_in_tmh
-------|---------|----------|-----------------------|---------
7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE
...    |...      |...       |...                    |...

## Estimated time

 * 8 seconds per gene ID, 
 * Must be done in sequence for NCBI
 * 8 seconds * 1123 jobs = 9000 secs = 150 mins = 3 hours
 

