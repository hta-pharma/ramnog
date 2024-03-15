test_that("multiplication works", {
  # SETUP -------------------------------------------------------------------
  testr::create_local_project()

  mk_ep_def <- function() {
    chef::mk_endpoint_str(
      data_prepare = mk_adae,
      pop_var = "SAFFL",
      pop_value = "Y",
      treatment_var = "TRT01A",
      treatment_refval = "Xanomeline High Dose",
      group_by = list(list(AESOC = c())),
      stratify_by = list(c("AEDECOD")),
      stat_by_strata_by_trt = list(chefStats::p_subj_event)
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
  targets::tar_make()
  targets::tar_load(ep_stat)
<<<<<<< HEAD

=======
>>>>>>> 62e189b (Adds junit as reporter)
})
