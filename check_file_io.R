# Prove that a list of tibbles (some of zero rows) can be saved and loaded

t_snps <- readr::read_csv(
  "100130933_snps.csv",
  col_types = readr::cols(
    snp_id = readr::col_double()
  )
)

tibbles <- list()

for (i in seq(11, 16)) {
  snp_id <- t_snps$snp_id[i]
  t <- tibble::tibble(
    snp_id = snp_id,
    variation = ncbi::get_snp_variations_in_protein_from_snp_id(
      snp_id
    )
  )
  tibbles[[i]] <- t
}

testthat::expect_true(is.null(tibbles[[1]]))


all_tibbles <- dplyr::bind_rows(tibbles)

filename <- tempfile()

saveRDS(object = tibbles, file = filename)

tibbles_again <- readRDS(file = filename)
testthat::expect_true(is.null(tibbles_again[[1]]))

all_tibbles_again <- dplyr::bind_rows(tibbles)

testthat::expect_equal(all_tibbles, all_tibbles_again)
