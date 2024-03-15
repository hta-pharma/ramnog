test_that("Demographics work with other endpoints", {
  # SETUP -------------------------------------------------------------------
  testr::create_local_project()

  mk_ep_def <- function() {
    ep <- chef::mk_endpoint_str(
      study_metadata = list(),
      pop_var = "SAFFL",
      pop_value = "Y",
      treatment_var = "TRT01A",
      treatment_refval = "Xanomeline High Dose",
      stratify_by = list(c("SEX", "AGEGR1")),
      data_prepare = mk_adae,
      endpoint_label = "A",
      custom_pop_filter =
        "TRT01A %in% c('Placebo', 'Xanomeline High Dose')",
      group_by = list(list(
        AESOC = c(), AESEV = c()
      )),
      stat_by_strata_by_trt = list("E" = chefStats::n_event),
      stat_by_strata_across_trt = list("RR" = chefStats::RR,
                                       "OR" = chefStats::OR),
      stat_across_strata_across_trt = list("P-interaction" = chefStats::p_val_interaction)
    )
    ep2 <-  chef::mk_endpoint_str(
      data_prepare = mk_advs,
      treatment_var = "TRT01A",
      treatment_refval = "Xanomeline High Dose",
      pop_var = "SAFFL",
      pop_value = "Y",
      stratify_by = list(c("AGEGR1", "SEX")),
      stat_by_strata_by_trt = list(chefStats::demographics_counts),
      endpoint_label = "Demographics endpoint (categorical measures)"
    )
    data.table::rbindlist(list(ep, ep2))
  }


  chef::use_chef(
    pipeline_dir = "pipeline",
    r_functions_dir = "R/",
    pipeline_id = "01",
    mk_endpoint_def_fn = mk_ep_def,
    mk_adam_fn = list(mk_adae, mk_advs),
  )
  # ACT ---------------------------------------------------------------------

  targets::tar_make()
  targets::tar_load(ep_stat)

  # EXPECT ------------------------------------------------------------------

  # Spot check the safety stats
  x <- mk_adae()
  actual <-
    ep_stat[endpoint_group_filter == "AESOC == \"SOCIAL CIRCUMSTANCES\" & AESEV == \"SEVERE\"" &
              fn_name == "RR" &
              stat_filter == "SEX == \"F\"" & stat_result_label == "RR", "stat_result_value"]
  x1 <- x[SEX == "F" & SAFFL == "Y"]
  x1[AESOC == "SOCIAL CIRCUMSTANCES" &
       AESEV == "SEVERE", event := TRUE]
  x1 <- unique(x1, by = "USUBJID")
  x1[, .N, by = .(TRT01A, event)]
  a <- 0.5 # Outcome, exposed
  b <- 35.5 # No outcome, exposed
  c <- 0.5 # No outcome, not exposed
  d <- 53.5 # No outcome, not exposed
  expected <- (a / sum(a, b)) / (c / sum(c, d))
  expect_identical(actual, expected)

  # Spot check the Demographic stats
  x <- mk_advs()
  a <- ep_stat[ stat_result_qualifiers == "SEX" & stat_result_label == "n_missing"] |> data.table::setorder(stat_filter)
  expected <- x[is.na(SEX), .N, by = .(TRT01A)] |> data.table::setorder(TRT01A)
  expect_equal(a$stat_result_value, expected$N)
})


