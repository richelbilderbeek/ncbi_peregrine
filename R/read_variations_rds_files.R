#' Read one or more \code{[gene_id]_variations.rds} file
#' @inheritParams default_params_doc
#' @return a list of lists of tibbles
#' @export
read_variations_rds_files <- function(variations_rds_filenames) {
  lists <- list()
  for (i in seq_len(length(variations_rds_filenames))) {
    lists[[i]] <- ncbiperegrine::read_variations_rds_file(
      variations_rds_filenames[i]
    )
  }
  lists
}
