if (1 == 2) {
t_gene_names <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)
testthat::expect_true("gene_id" %in% names(t_gene_names))
testthat::expect_true("gene_name" %in% names(t_gene_names))
t_gene_names$filename <- paste0(t_gene_names$gene_id, ".csv")
t_gene_names$snp_ids_filename <- paste0(t_gene_names$gene_id, "_snps.csv")
t_gene_names$variations_filename <- paste0(t_gene_names$gene_id, "_variations.csv")
t_gene_names$is_in_tmh_filename <- paste0(t_gene_names$gene_id, "_is_in_tmh.csv")

#
# Create t_results for the first three columns
#
#        t_results_1
# |---------------------------|
#
# gene_id|gene_name|snp_id    |variation              |is_in_tmh|p_in_tmh
# -------|---------|----------|-----------------------|---------|--------
# 7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.123
# ...    |...      |...       |...                    |...      |...
#
# |----------------|
#   gene_names.csv
#
#                  |----------|
#                  [gene_name]_snps.csv
#
# Get all SNP IDs per gene name
t_snp_ids <- list()
gene_names <- t_gene_names$gene_name
n_gene_names <- length(gene_names)
for (i in seq_len(n_gene_names)) {
  testthat::expect_true(i <= nrow(t_gene_names))
  testthat::expect_true(file.exists(t_gene_names$snp_ids_filename[i]))
  t <- readr::read_csv(
    file = t_gene_names$snp_ids_filename[i],
    col_types = readr::cols(
      snp_id = readr::col_double()
    )
  )
  t$gene_name <- t_gene_names$gene_name[i]

  t_snp_ids[[i]] <- t
}
t_snp_ids <- dplyr::bind_rows(t_snp_ids)

library(dplyr)
t_results_1 <- dplyr::full_join(
  t_gene_names %>% dplyr::select(c("gene_id", "gene_name")),
  t_snp_ids,
  by = "gene_name",
)
testthat::expect_equal(nrow(t_results_1), nrow(t_snp_ids))
t_results_1

#
# Create t_results for the first four columns
#
#         t_results_1
# |---------------------------|
#
#                     t_results_2
# |---------------------------------------------------|
#
# gene_id|gene_name|snp_id    |variation              |is_in_tmh|p_in_tmh
# -------|---------|----------|-----------------------|---------|--------
# 7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.123
# ...    |...      |...       |...                    |...      |...
#
# |----------------|
#   gene_names.csv
#
#                  |----------|
#                  [gene_name]_snps.csv
#
#                  |----------------------------------|
#                       [gene_name]_variations.csv
#
t_results_1

t_variations <- list()
gene_names <- t_gene_names$gene_name
n_gene_names <- length(gene_names)
for (i in seq_len(n_gene_names)) {
  testthat::expect_true(i <= nrow(t_gene_names))
  testthat::expect_true(file.exists(t_gene_names$variations_filename[i]))
  t <- readr::read_csv(
    file = t_gene_names$variations_filename[i],
    col_types = readr::cols(
      snp_id = readr::col_double(),
      variation = readr::col_character()
    )
  )
  t$gene_name <- t_gene_names$gene_name[i]

  t_variations[[i]] <- t
}
t_variations <- dplyr::bind_rows(t_variations)

testthat::expect_true(all(t_variations$snp_id %in% t_results_1$snp_id))

t_results_2 <- dplyr::inner_join(
  x = t_results_1,
  y = t_variations,
  by = c("gene_name", "snp_id")
)
testthat::expect_equal(nrow(t_results_2), nrow(t_variations))
t_results_2

# Create t_results for all columns
#
#                     t_results_2
# |---------------------------------------------------|
#
#                     t_results
# |---------------------------------------------------------------------|
#
# gene_id|gene_name|snp_id    |variation              |is_in_tmh|p_in_tmh
# -------|---------|----------|-----------------------|---------|--------
# 7124   |TNF      |1583049783|NP_000585.2:p.Gly144Asp|FALSE    |0.123
# ...    |...      |...       |...                    |...      |...
#
# |----------------|
#   gene_names.csv
#
#                  |----------|
#                  [gene_name]_snps.csv
#
#                  |----------------------------------|
#                       [gene_name]_variations.csv
#
#                             |------------------------------------------|
#                                      [gene_name]_is_in_tmh.csv

t_is_in_tmh <- list()
gene_names <- t_gene_names$gene_name
n_gene_names <- length(gene_names)
for (i in seq_len(n_gene_names)) {
  testthat::expect_true(i <= nrow(t_gene_names))
  testthat::expect_true(file.exists(t_gene_names$is_in_tmh_filename[i]))
  t <- readr::read_csv(
    file = t_gene_names$is_in_tmh_filename[i],
    col_types = readr::cols(
      variation = readr::col_character(),
      is_in_tmh = readr::col_logical(),
      p_in_tmh = readr::col_double()
    )
  )
  t
  t_is_in_tmh[[i]] <- t
}
t_is_in_tmh <- dplyr::bind_rows(t_is_in_tmh)


t_results <- dplyr::inner_join(
  x = t_results_2,
  y = t_is_in_tmh,
  by = "variation"
)
testthat::expect_equal(nrow(t_results_2), nrow(t_is_in_tmh))
t_results

readr::write_csv(x = t_results, file = "results_raw.csv")

readr::write_csv(x = na.omit(t_results), file = "results.csv")

}
