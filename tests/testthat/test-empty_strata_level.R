test_that("stat funtion that produces a 0 returns result ",
          {
            # SETUP -------------------------------------------------------------------
            testr::create_local_project()
            crit_endpoint <- function(...) {
              return(T)
            }
            crit_sga <- function(...) {
              return(T)
            }
            crit_sgd <- function(...) {
              return(T)
            }

            mk_ep_def <- function() {
              ep <- chef::mk_endpoint_str(
                study_metadata = list(),
                pop_var = "SAFFL",
                pop_value = "Y",
                treatment_var = "TRT01A",
                treatment_refval = "Xanomeline High Dose",
                data_prepare = mk_adae,
                endpoint_label = "A",
                custom_pop_filter = "SEX == 'F'",
                endpoint_filter = "AESEV == \"SEVERE\"",
                group_by = list(list(AESOC = c("GASTROINTESTINAL DISORDERS"))),
                stat_by_strata_by_trt = list("N" = chefStats::n_subj_event)
              )
            }


            chef::use_chef(
              pipeline_dir = "pipeline",
              r_functions_dir = "R/",
              pipeline_id = "01",
              mk_endpoint_def_fn = mk_ep_def,
              mk_adam_fn = list(mk_adae),
              mk_criteria_fn = list(crit_endpoint, crit_sga, crit_sgd)
            )
            # ACT ---------------------------------------------------------------------
            targets::tar_make()
            targets::tar_load(ep_stat)
            # EXPECT ------------------------------------------------------------------


            actual <-
              ep_stat[grepl("Placebo", stat_filter), value]
            expect_equal(actual, 0)
          })
