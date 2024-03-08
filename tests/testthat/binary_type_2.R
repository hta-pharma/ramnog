test_that("Binary outcomes of type 2 work", {
  # SETUP -------------------------------------------------------------------
  testr::create_local_project()

  mk_ep_def <- function(){
  chef::mk_endpoint_str(
    data_prepare = mk_adae,
    pop_var = "SAFFL",
    pop_value = "Y",
    treatment_var = "TRT01A",
    treatment_refval = "Xanomeline High Dose",
    group_by = list(list(AESOC = c())),
    stratify_by = list(c("AEDECOD")),
    stat_by_strata_by_trt = list(chefStats::n_subj_event,
                                 chefStats::n_event)
  )
}
  chef::use_chef(
    pipeline_dir = "pipeline",
    r_functions_dir = "R/",
    pipeline_id = "01",
    mk_endpoint_def_fn = mk_ep_def,
    mk_adam_fn = list(mk_adae),
  )
  # ACT ---------------------------------------------------------------------
  browser()
  targets::tar_make()
  targets::tar_load(ep_stat)

  # EXPECT ------------------------------------------------------------------
  actual <-
    tidyr::unnest(ep_stat[grepl("GASTRO", endpoint_group_filter) |
                            grepl("CARDIAC", endpoint_group_filter),
                          .(endpoint_group_filter,
                            stat_filter,
                            stat_empty,
                            fn_name,
                            stat_result)], cols = stat_result) |>
    setDT() |>
    setorder(-value)

  x <- mk_adae()
  n <- x[AESOC == "CARDIAC DISORDERS" &
      AEDECOD == "SINUS BRADYCARDIA" & TRT01A == "Xanomeline High Dose"] |> uniqueN(by="USUBJID")
  E <- x[AESOC == "CARDIAC DISORDERS" &
      AEDECOD == "SINUS BRADYCARDIA" & TRT01A == "Xanomeline High Dose"] |> nrow()

  actual_values <- actual[grepl("CARDIAC", endpoint_group_filter) &
           grepl("SINUS BRADYCARDIA", stat_filter) &
           grepl("Xan", stat_filter)&(label == "n" |
           label == "E")][order(label)][,value]
expect_equal(actual_values, c(E, n))

})
