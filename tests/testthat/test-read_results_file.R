test_that("use", {
  results_filename <- system.file(
    "extdata",
    "results.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(results_filename))

  t_results <- read_results_file(results_filename)

  expect_true(tibble::is_tibble(t_results))
  expect_equal(
    names(t_results),
    c("gene_id", "gene_name", "snp_id", "variation", "is_in_tmh", "p_in_tmh")
  )
  expect_equal(nrow(t_results), 80)
})

test_that("remove duplicates", {
  results_filename <- system.file(
    "extdata",
    "results_with_duplicates.csv",
    package = "ncbiperegrine"
  )
  expect_true(file.exists(results_filename))
  t_results <- read_results_file(results_filename)

  expect_equal(nrow(dplyr::distinct(t_results)), 4)
  expect_equal(nrow(t_results), 4)
})

test_that("Results of research", {
  skip("local only")
  results_filename <- "~/GitHubs/ncbi_peregrine/scripts/results.csv"

  # Raw
  t_results <- read_results_file(results_filename)
  expect_equal(nrow(t_results), nrow(dplyr::distinct(t_results)))
  n_variations_raw <- length(t_results$variation)
  expect_equal(n_variations_raw, 60931)
  n_unique_variations_raw <- length(unique(t_results$variation))
  expect_equal(n_unique_variations_raw, 60544)
  n_unique_gene_ids_raw <- length(unique(t_results$gene_id))
  expect_equal(n_unique_gene_ids_raw, 953)
  n_unique_gene_names_raw <- length(unique(t_results$gene_name))
  expect_equal(n_unique_gene_names_raw, 953)
  t_results$name <- stringr::str_match(
    string = t_results$variation,
    pattern = "^(.*):p\\..*$"
  )[, 2]
  n_protein_names_raw <- length(unique(t_results$name))
  expect_equal(5163, n_protein_names_raw)

  # Proteins
  t_snps <- dplyr::filter(t_results, ncbi::are_snps(variation))
  expect_equal(nrow(t_snps), nrow(dplyr::distinct(t_snps)))
  n_variations <- length(t_snps$variation)
  expect_equal(37831, n_variations)
  n_unique_variations <- length(unique(t_snps$variation))
  expect_equal(37630, n_unique_variations)
  n_unique_snp_ids <- length(unique(t_snps$snp_id))
  expect_equal(9621, n_unique_snp_ids)
  n_unique_gene_ids <- length(unique(t_snps$gene_id))
  expect_equal(n_unique_gene_ids, 911)
  n_unique_gene_names <- length(unique(t_snps$gene_name))
  expect_equal(n_unique_gene_names, 911)

  n_unique_protein_names <- length(unique(t_snps$name))
  expect_equal(4780, n_unique_protein_names)
  f_tmh <- mean(
    dplyr::summarise(
      dplyr::group_by(
        dplyr::select(t_snps, name, p_in_tmh),
        name
      ),
      f_in_tmh = mean(p_in_tmh)
    )$f_in_tmh
  )
  expect_equal(0.09978325, f_tmh)

  # Membrane Associated Proteins
  t_snps_map <- dplyr::filter(t_snps, p_in_tmh == 0.0)
  expect_equal(nrow(t_snps_map), nrow(dplyr::distinct(t_snps_map)))
  n_variations_map <- length(t_snps_map$variation)
  expect_equal(16623, n_variations_map)
  n_unique_variations_map <- length(unique(t_snps_map$variation))
  expect_equal(16606, n_unique_variations_map)
  n_unique_snp_ids_map <- length(unique(t_snps_map$snp_id))
  expect_equal(4219, n_unique_snp_ids_map)
  n_unique_gene_ids_map <- length(unique(t_snps_map$gene_id))
  expect_equal(n_unique_gene_ids_map, 457)
  n_unique_gene_names_map <- length(unique(t_snps_map$gene_name))
  expect_equal(n_unique_gene_names_map, 457)
  n_unique_protein_names_map <- length(unique(t_snps_map$name))
  expect_equal(2227, n_unique_protein_names_map)
  f_tmh_map <- mean(
    dplyr::summarise(
      dplyr::group_by(
        dplyr::select(t_snps_map, name, p_in_tmh),
        name
      ),
      f_in_tmh = mean(p_in_tmh)
    )$f_in_tmh
  )
  expect_equal(0.00000, f_tmh_map)

  # Trans-Membrane Proteins
  t_snps_tmp <- dplyr::filter(t_snps, p_in_tmh > 0.0)
  expect_equal(nrow(t_snps_tmp), nrow(dplyr::distinct(t_snps_tmp)))
  n_variations_tmp <- length(t_snps_tmp$variation)
  expect_equal(21208, n_variations_tmp)
  n_unique_variations_tmp <- length(unique(t_snps_tmp$variation))
  expect_equal(21024, n_unique_variations_tmp)
  n_unique_snp_ids_tmp <- length(unique(t_snps_tmp$snp_id))
  expect_equal(6026, n_unique_snp_ids_tmp)
  n_unique_gene_ids_tmp <- length(unique(t_snps_tmp$gene_id))
  expect_equal(n_unique_gene_ids_tmp, 605)
  n_unique_gene_names_tmp <- length(unique(t_snps_tmp$gene_name))
  expect_equal(n_unique_gene_names_tmp, 605)
  n_unique_protein_names_tmp <- length(unique(t_snps_tmp$name))
  expect_equal(2553, n_unique_protein_names_tmp)
  f_tmh_tmp <- mean(
    dplyr::summarise(
      dplyr::group_by(
        dplyr::select(t_snps_tmp, name, p_in_tmh),
        name
      ),
      f_in_tmh = mean(p_in_tmh)
    )$f_in_tmh
  )
  expect_equal(0.1868249, f_tmh_tmp, tol = 0.0001)

  # Count the SNPs that are associated with both MAPs and TMPs
  duplicate_snp_ids <- unique(
    t_snps_map$snp_id[t_snps_map$snp_id %in% t_snps_tmp$snp_id]
  )
  n_duplicate_snp_ids <- length(duplicate_snp_ids)
  expect_equal(624, n_duplicate_snp_ids)
  expect_equal(
    n_unique_snp_ids,
    n_unique_snp_ids_map + n_unique_snp_ids_tmp - n_duplicate_snp_ids
  )

  # Count the gene names that are associated with both MAPs and TMPs
  duplicate_gene_names <- unique(
    t_snps_map$gene_name[t_snps_map$gene_name %in% t_snps_tmp$gene_name]
  )
  n_duplicate_gene_names <- length(duplicate_gene_names)
  expect_equal(151, n_duplicate_gene_names)
  expect_equal(
    n_unique_gene_ids,
    n_unique_gene_ids_map + n_unique_gene_ids_tmp - n_duplicate_gene_names
  )
})
