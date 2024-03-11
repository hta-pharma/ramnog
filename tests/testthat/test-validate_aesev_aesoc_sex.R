test_that("Validate statistics - complex endpoint specification",
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
                stratify_by = list(c("SEX", "AGEGR1")),
                data_prepare = mk_adae,
                endpoint_label = "A",
                custom_pop_filter =
                  "TRT01A %in% c('Placebo', 'Xanomeline High Dose')",
                group_by = list(list(
                  AESOC = c(), AESEV = c()
                )),
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
              mk_adam_fn = list(mk_adae),
              mk_criteria_fn = list(crit_endpoint, crit_sga, crit_sgd)
            )
            # ACT ---------------------------------------------------------------------
            targets::tar_make()
            targets::tar_load(ep_stat)
            # EXPECT ------------------------------------------------------------------

            x <- mk_adae()
            actual <-
              ep_stat[endpoint_group_filter == "AESOC == \"SOCIAL CIRCUMSTANCES\" & AESEV == \"SEVERE\"" &
                        fn_name == "RR" &
                        stat_filter == "SEX == \"F\"" & stat_result_label == "RR", stat_result_value]
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

            actual <-
              ep_stat[endpoint_group_filter == "AESOC == \"SOCIAL CIRCUMSTANCES\" & AESEV == \"SEVERE\"" &
                        fn_name == "OR" &
                        stat_filter == "SEX == \"F\"" &
                        stat_result_label == "OR", stat_result_value]
            expected <- (a / b) / (c / d)
            expect_identical(actual, expected)
          })


test_that("Valide stats when one strata level is not found",
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
                stratify_by = list(c("SEX")),
                data_prepare = mk_adae,
                endpoint_label = "A",
                custom_pop_filter = "SEX == 'F'",
                group_by = list(list(AESEV = c())),
                stat_by_strata_by_trt = list(
                  "N" = chefStats::n_subj,
                  "E" = chefStats::n_event,
                  "N subj E" = chefStats::n_subj_event
                ),
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
              mk_adam_fn = list(mk_adae),
              mk_criteria_fn = list(crit_endpoint, crit_sga, crit_sgd)
            )
            # ACT ---------------------------------------------------------------------
            targets::tar_make()
            targets::tar_load(ep_stat)
            # EXPECT ------------------------------------------------------------------
            x <- mk_adae()
            # Relative Risk
            actual <-
              ep_stat[endpoint_group_filter == "AESEV == \"SEVERE\"" &
                        fn_name == "RR" &
                        stat_filter == "SEX == \"F\"" &
                        stat_result_label == "RR", stat_result_value]
            x1 <- x[SEX == "F" & SAFFL == "Y"]
            x1[, event := FALSE]
            x1[AESEV == "SEVERE", event := TRUE] |> setorder(-event)
            x1_unique <-
              unique(x1, by = "USUBJID", fromLast = FALSE)
            two_by_two <-
              x1_unique[, .N, by = .(TRT01A, event)][order(TRT01A, event)]
            a <-
              two_by_two[TRT01A == "Xanomeline High Dose" &
                           (event), N] # Outcome, exposed
            b <-
              two_by_two[TRT01A == "Xanomeline High Dose" &
                           !(event), N] # No outcome, exposed
            c <-
              two_by_two[TRT01A == "Placebo" &
                           (event), N] # No outcome, not exposed
            d <-
              two_by_two[TRT01A == "Placebo" &
                           !(event), N] # No outcome, not exposed
            expected <- (a / sum(a, b)) / (c / sum(c, d))
            expect_identical(actual, expected)

            # Numeber of Events
            actual <-
              ep_stat[endpoint_group_filter == "AESEV == \"SEVERE\"" &
                        fn_name == "E" &
                        strata_var == "SEX"]
            expected <-
              x1[(event), .N, by = .(TRT01A)][order(TRT01A)][, as.double(N)]
            expect_identical(actual$stat_result_value, expected)
          })
