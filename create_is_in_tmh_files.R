t <- readr::read_csv(
  file = "gene_names.csv",
  col_types = readr::cols(
    gene_id = readr::col_double(),
    gene_name = readr::col_character()
  )
)
testthat::expect_true("gene_id" %in% names(t))
testthat::expect_true("gene_name" %in% names(t))
t$topo_filename <- paste0(t$gene_id, ".topo")
t$variations_filename <- paste0(t$gene_id, "_variations.csv")
t$is_in_tmh_filename <- paste0(t$gene_id, "_is_in_tmh.csv")

# i <- 201
# variation will be a frame shift

# i <- 210
# variation will be NP_068743.3:p.Ter846TyrextTer?

# i <- 398
# NP_001172112.1:p.Arg249delinsThrGluArgTer

# i <- 762
# NP_001180552.1:p.Pro27del


for (i in seq_len(nrow(t))) {

  # The gene
  gene_name <- t$gene_name[i]
  message(i, "/", nrow(t), ": ", gene_name)

  # The variations filename
  variations_filename <- t$variations_filename[i]
  testthat::expect_true(file.exists(variations_filename))
  t_variations  <- readr::read_csv(
    variations_filename,
    col_types = readr::cols(
      snp_id = readr::col_double(),
      variation = readr::col_character()
    )
  )

  # The topo filename
  topo_filename <- t$topo_filename[i]
  testthat::expect_true(file.exists(topo_filename))
  t_topo  <- pureseqtmr::load_fasta_file_as_tibble(topo_filename)
  testthat::expect_equal(nrow(t_variations), nrow(t_topo))

  if (nrow(t_topo) == 0) {
    t_is_in_tmh <- tibble::tibble(
      variation = character(0),
      is_in_tmh = logical(0),
      p_in_tmh = double(0)
    )

  } else {

    # Score
    t_is_in_tmh <- tibble::tibble(
      variation = t_variations$variation,
      is_in_tmh = NA,
      p_in_tmh = NA
    )

    # Determine in_in_tmh
    for (variation_index in seq(1, nrow(t_is_in_tmh))) {
      message(variation_index, "/", nrow(t_is_in_tmh), ": ",  t_variations$variation[variation_index])
      tryCatch({
        this_variation <- ncbi::parse_hgvs(
          t_variations$variation[variation_index]
        )
        if (this_variation$from != this_variation$to) {
          pos <- this_variation$pos
          t_is_in_tmh$is_in_tmh[variation_index] <- "1" == stringr::str_sub(
            t_topo$sequence[variation_index], pos, pos)
              # Determine p_in_tmh
            t_is_in_tmh$p_in_tmh <- stringr::str_count(t_topo$sequence, "1") /
                nchar(t_topo$sequence)
        }
      }, error = function(e) {
          # Valid reasons to skip
          testthat::expect_match(e$message, "Do no accept (frame shifts|extensions|insertions|deletions|delins)")
        }
      )
    }
  }
  # Save
  readr::write_csv(
    x = t_is_in_tmh,
    file = t$is_in_tmh_filename[i]
  )
  testthat::expect_true(file.exists(t$is_in_tmh_filename[i]))
}

readr::write_lines(
  x = Sys.time(),
  file = "create_is_in_tmh_files_is_done.txt"
)
