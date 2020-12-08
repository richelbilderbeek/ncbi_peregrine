#' Read
#' @inheritParams default_params_doc
#' @export
read_variations_csv_files <- function(variations_csv_filenames) {
  testthat::expect_true(all(file.exists(variations_csv_filenames)))
  t_variations <- list()
  n <- length(variations_csv_filenames)
  for (i in seq_len(n)) {
    t <- ncbiperegrine::read_variations_csv_file(
      variations_csv_filename = variations_csv_filenames[i]
    )
    gene_id <- as.numeric(
      basename(
        stringr::str_replace(
          string = variations_csv_filenames[i],
          pattern = "_variations.csv",
          replacement = ""
        )
      )
    )
    t$gene_id <- gene_id

    t_variations[[i]] <- t
  }
  dplyr::select(
    dplyr::bind_rows(t_variations),
    "gene_id", "snp_id", "variation"
  )
}
