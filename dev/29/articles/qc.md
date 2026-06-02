# Quality control for ramnog ecosystem

The validity of the {ramnog} framework is ensured on several levels:

- Unit test individual functions/modules in all packages
- Integration/end-to-end testing to ensure the interactions between
  individual functions/modules (that have been unit tested) are as
  expected
- CI/CD to ensure changes are properly tested and deployed to the users

## Unit testing

Each package contains the unit tests for the functionality that package
is responsible for. This means, for example, it is the responsibility of
the unit-tests in {chefStats} to ensure that the statistical functions
written in chefStats produce the result they are supposed to produce.

## Integration testing

Integration testing verifies the framework produces the expected results

The integration testing is done via the {testthat} framework, and are
essentially unit-tests that cover many different units

The goal is to compare the results of an analysis run via ramnog with
the expected results done from a manual calculation of the same
analysis.

For example, below is the unit test to ensure the results of an endpoint
definition defined and run via chef match those calculated manually

Example of integration test using {testthat} framework

``` r

testthat::test_that("Valide stats when one strata level is not found",
          {
            # SETUP -------------------------------------------------------------------
            tmp <- withr::local_tempdir()
            dir.create(file.path(tmp, "R"))
            withr::local_dir(tmp)
            usethis::local_project(tmp, force = TRUE, setwd = FALSE, quiet = TRUE)
            mk_adae <- function(study_metadata) {
              adsl <- pharmaverseadam::adsl |> data.table::setDT()
              adae <- pharmaverseadam::adae |> data.table::setDT()
              adae_out <-
                merge(adsl, adae[, c(setdiff(names(adae), names(adsl)), "USUBJID"), with =
                                   F], by = "USUBJID", all = TRUE)
              adae_out[TRT01A %in% c('Placebo', 'Xanomeline High Dose'),]
            }
            mk_ep_def <- function() {
              chef::mk_endpoint_str(
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
              mk_adam_fn = list(mk_adae)
            )
            # ACT ---------------------------------------------------------------------
            targets::tar_make()
            targets::tar_load(ep_stat)
            # EXPECT ------------------------------------------------------------------
            # Manually calculated expected results
            x <- mk_adae(study_metadata = NULL)
            # Relative Risk
            actual <-
              ep_stat[endpoint_group_filter == "AESEV == \"SEVERE\"" &
                        fn_name == "RR" &
                        stat_filter == "SEX == \"F\"" & stat_result_label == "RR", stat_result_value]
            x1 <- x[SEX == "F" & SAFFL == "Y"]
            x1[, event := FALSE]
            x1[AESEV == "SEVERE", event := TRUE] |> data.table::setorder(-event)
            x1_unique <-
              unique(x1, by = "USUBJID", fromLast = FALSE)
            two_by_two <-
              x1_unique[, .N, by = .(TRT01A, event)][order(TRT01A, event)]
            
            # Outcome, exposed
            a <-
              two_by_two[TRT01A == "Xanomeline High Dose" &
                           (event), N] 
            
            # No outcome, exposed
            b <-
              two_by_two[TRT01A == "Xanomeline High Dose" &
                           !(event), N] 
             
            # Outcome, not exposed
            c <-
              two_by_two[TRT01A == "Placebo" &
                           (event), N]
            
            # No outcome, not exposed
            d <-
              two_by_two[TRT01A == "Placebo" &
                           !(event), N] 
            
            expected <- (a / sum(a, b)) / (c / sum(c, d))
            expect_identical(actual, expected)

            # Number of Events
            actual <-
              ep_stat[endpoint_group_filter == "AESEV == \"SEVERE\"" &
                        fn_name == "E" &
                        strata_var == "SEX"]
            expected <-
              x1[(event), .N, by = .(TRT01A)][order(TRT01A)][, as.double(N)]
            expect_identical(actual$stat_result_value, expected)
          })
#> i Renaming "mk_ep_def" to "mk_endpoint_def.R"
#> Loading required package: targets
#> 
#> Attaching package: ‘data.table’
#> 
#> The following object is masked from ‘package:base’:
#> 
#>     %notin%
#> 
#> + ep dispatched
#> ✔ ep completed [28ms, 571 B]
#> + ep_id dispatched
#> ✔ ep_id completed [9ms, 605 B]
#> + ep_fn_map declared [1 branches]
#> ✔ ep_fn_map completed [37ms, 536 B]
#> + user_def_fn dispatched
#> ✔ user_def_fn completed [5ms, 8.14 kB]
#> + study_data dispatched
#> ✔ study_data completed [44ms, 55.31 kB]
#> + fn_map_tibble dispatched
#> ✔ fn_map_tibble completed [8ms, 8.30 kB]
#> + ep_and_data declared [1 branches]
#> ✔ ep_and_data completed [11ms, 29.26 kB]
#> + fn_map declared [1 branches]
#> ✔ fn_map completed [0ms, 8.28 kB]
#> + analysis_data_container declared [1 branches]
#> ✔ analysis_data_container completed [0ms, 28.61 kB]
#> + ep_with_data_key declared [1 branches]
#> ✔ ep_with_data_key completed [0ms, 712 B]
#> + ep_expanded declared [1 branches]
#> ✔ ep_expanded completed [39ms, 629 B]
#> + ep_event_index declared [1 branches]
#> ✔ ep_event_index completed [7ms, 1.38 kB]
#> + ep_crit_endpoint declared [1 branches]
#> ✔ ep_crit_endpoint completed [5ms, 1.40 kB]
#> + ep_crit_by_strata_by_trt declared [1 branches]
#> ✔ ep_crit_by_strata_by_trt completed [11ms, 1.50 kB]
#> + ep_crit_by_strata_across_trt declared [1 branches]
#> ✔ ep_crit_by_strata_across_trt completed [5ms, 1.51 kB]
#> + ep_prep_by_strata_across_trt declared [1 branches]
#> ✔ ep_prep_by_strata_across_trt completed [50ms, 9.88 kB]
#> + ep_prep_across_strata_across_trt declared [1 branches]
#> ✔ ep_prep_across_strata_across_trt completed [15ms, 7.56 kB]
#> + ep_prep_by_strata_by_trt declared [1 branches]
#> ✔ ep_prep_by_strata_by_trt completed [108ms, 10.06 kB]
#> + ep_rejected dispatched
#> ✔ ep_rejected completed [0ms, 412 B]
#> + ep_stat_by_strata_across_trt declared [1 branches]
#> ✔ ep_stat_by_strata_across_trt completed [133ms, 2.93 kB]
#> + ep_stat_across_strata_across_trt declared [1 branches]
#> ✔ ep_stat_across_strata_across_trt completed [39ms, 2.17 kB]
#> + ep_stat_by_strata_by_trt declared [1 branches]
#> ✔ ep_stat_by_strata_by_trt completed [60ms, 3.38 kB]
#> + ep_stat_nested dispatched
#> ✔ ep_stat_nested completed [0ms, 4.55 kB]
#> + ep_stat dispatched
#> ✔ ep_stat completed [12ms, 5.08 kB]
#> ✔ ended pipeline [1.2s, 24 completed, 0 skipped]
#> Test passed with 2 successes 🥇.
```

## CI/CD

Please see the
[DevOps](https://hta-pharma.github.io/ramnog/articles/dev_devops.md)
vignette for details on the CI/CD infrastructure.
