test_that("Complex pipeline runs without errors",
          {
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
                custom_pop_filter = "TRT01A %in% c('Placebo', 'Xanomeline High Dose')",
                group_by = list(list(AESOC = c(), AESEV=c())),
                stat_by_strata_by_trt = list("N" = chefStats::n_subj,
                                             "E" = chefStats::n_event),
                stat_by_strata_across_trt = list("RR" = chefStats::RR,
                                                 "OR" = chefStats::OR),
                stat_across_strata_across_trt = list("P-interaction" = chefStats::p_val_interaction)
              )
            }


            chef::use_chef(
              pipeline_dir = "pipeline",
              r_functions_dir = "R/",
              pipeline_id = "01",
              mk_endpoint_def_fn = mk_ep_def,
              mk_adam_fn = list(mk_adae)
            )
            # ACT ---------------------------------------------------------------------
            targets::tar_make()

            # EXPECT ------------------------------------------------------------------
            x <- targets::tar_meta() |> data.table::as.data.table()
            targets::tar_load(ep_stat)
            ep_stat <- ep_stat[order(c(endpoint_id,
                                       strata_var,
                                       fn_type,
                                       fn_name,
                                       stat_filter,
                                       stat_result_label, 
                                       stat_result_description)), ]

            expect_true(all(is.na(x$error)))
            expect_snapshot(ep_stat[, .(stat_filter,
                                        endpoint_group_filter,
                                        stat_result_label,
                                        stat_result_description,
                                        stat_result_qualifiers,
                                        stat_result_value)])
          })