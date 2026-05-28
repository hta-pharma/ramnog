# Processing of Strata without Events

## Overview

The `only_strata_with_events` endpoint parameter specifies whether the
output data will include all strata levels or only those levels that
contain events. By default, all levels will be included in the endpoint

Note: If there is a minimum of one event present in any treatment arm
within a specific strata level, that level will be incorporated into the
endpoint for all treatment arms regardsless of whether one of the
treatment arms has no events in that stratum.

This functionality is useful in cases where the endpoint specification
contains groups and strata that result in many 100s or 1000s of
combinations and where only the combinations with events are of
interest. In this case `only_strata_with_events` can be set to `TRUE` to
remove the irrelevant combinations and save computation time.

## Examples

###### Ex 7.1

Let us consider the following endpoint specification, where `mk_adae` is
defined as in the [Quick
Start](https://hta-pharma.github.io/ramnog/articles/ramnog.md), and
grouping is performed on SOC (System Organ Class) and stratification is
performed on race. By default, all strata levels are included,
i.e. `only_strata_with_events = FALSE`.

``` r

ep_spec_ex7_1 <- chef::mk_endpoint_str(
  data_prepare = mk_adae,
  study_metadata = list(),
  pop_var = "SAFFL",
  pop_value = "Y",
  custom_pop_filter = "TRT01A %in% c('Placebo', 'Xanomeline High Dose') & !is.na(AESOC)",
  treatment_var = "TRT01A",
  treatment_refval = "Xanomeline High Dose",
  group_by = list(list(AESOC = c())),
  stratify_by = list(c("RACE")),
  stat_by_strata_by_trt = list(N = chefStats::n_subj, n = chefStats::n_subj_event),
  endpoint_label = "AESOC: <AESOC>",
  only_strata_with_events = FALSE
)
```

In this setup we note:

- `TRT01A` has 2 treatment arms in the analysis data due to
  `custom_pop_filter`
- `group_by`: `AESOC` has 23 levels
- `stratify_by`: `RACE` has 4 levels
- `stat_by_strata_by_trt`: 2 statistics per combination of group level
  and strata level

For each SOC this implies:

- Strata = `TOTAL`: 2 treatment arms x 2 statistics = 4 combinations
- Strata = `RACE`: 2 treatment arms x 3 races x 2 statistics = 12
  combinations

Thus we have 23 SOCs x (4 + 12) = 368 combinations, i.e. 368 rows in the
output data.

Specifically, let us consider the SOC “Eye Disorder” and print the the
subset of the output data that covers that SOC (see below). As expected
4 + 12 = 16 rows are provided. We also notice that two of the strata
levels for `RACE` has no event (`n` = 0), which leads to the next
example.

``` r

ep_stat[endpoint_label == "AESOC: EYE DISORDERS", c("stat_filter", "fn_name", "stat_result_value")]
#>                                                                       stat_filter
#>                                                                            <char>
#>  1:                                       TOTAL_ == "total" & TRT01A == "Placebo"
#>  2:                                       TOTAL_ == "total" & TRT01A == "Placebo"
#>  3:                          TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"
#>  4:                          TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"
#>  5:                                         RACE == "WHITE" & TRT01A == "Placebo"
#>  6:                                         RACE == "WHITE" & TRT01A == "Placebo"
#>  7:                     RACE == "BLACK OR AFRICAN AMERICAN" & TRT01A == "Placebo"
#>  8:                     RACE == "BLACK OR AFRICAN AMERICAN" & TRT01A == "Placebo"
#>  9:              RACE == "AMERICAN INDIAN OR ALASKA NATIVE" & TRT01A == "Placebo"
#> 10:              RACE == "AMERICAN INDIAN OR ALASKA NATIVE" & TRT01A == "Placebo"
#> 11:                            RACE == "WHITE" & TRT01A == "Xanomeline High Dose"
#> 12:                            RACE == "WHITE" & TRT01A == "Xanomeline High Dose"
#> 13:        RACE == "BLACK OR AFRICAN AMERICAN" & TRT01A == "Xanomeline High Dose"
#> 14:        RACE == "BLACK OR AFRICAN AMERICAN" & TRT01A == "Xanomeline High Dose"
#> 15: RACE == "AMERICAN INDIAN OR ALASKA NATIVE" & TRT01A == "Xanomeline High Dose"
#> 16: RACE == "AMERICAN INDIAN OR ALASKA NATIVE" & TRT01A == "Xanomeline High Dose"
#>     fn_name stat_result_value
#>      <char>             <num>
#>  1:       N                69
#>  2:       n                 4
#>  3:       N                70
#>  4:       n                 1
#>  5:       N                63
#>  6:       n                 4
#>  7:       N                 6
#>  8:       n                 0
#>  9:       N                 0
#> 10:       n                 0
#> 11:       N                61
#> 12:       n                 1
#> 13:       N                 8
#> 14:       n                 0
#> 15:       N                 1
#> 16:       n                 0
```

###### Ex 7.2

Suppose that we are only interested in the combinations of group levels
and strata levels in example 7.1 that have events. To accomplish this we
may specify `only_strata_with_events = TRUE`.

``` r

ep_spec_ex7_2 <- chef::mk_endpoint_str(
  data_prepare = mk_adae,
  study_metadata = list(),
  pop_var = "SAFFL",
  pop_value = "Y",
  custom_pop_filter = "TRT01A %in% c('Placebo', 'Xanomeline High Dose') & !is.na(AESOC)",
  treatment_var = "TRT01A",
  treatment_refval = "Xanomeline High Dose",
  group_by = list(list(AESOC = c())),
  stratify_by = list(c("RACE")),
  stat_by_strata_by_trt = list(N = chefStats::n_subj, n = chefStats::n_subj_event),
  endpoint_label = "AESOC: <AESOC>",
  only_strata_with_events = TRUE
)
```

Now the number of combination in the output has been reduced to 256.

Let us revisit the SOC “Eye Disorder” and print all rows in the output
that relate to that SOC (see below). We notice that 2 strata levels for
`RACE` are not present anymore (“BLACK OR AFRICAN AMERICAN”, “AMERICAN
INDIAN OR ALASKA NATIVE”) since they have no events c.f. example 7.1.,
which effectively reduces the number of rows/combinations to 8 for this
SOC.

``` r

ep_stat[endpoint_label == "AESOC: EYE DISORDERS", c("stat_filter", "fn_name", "stat_result_value")]
#>                                             stat_filter fn_name
#>                                                  <char>  <char>
#> 1:              TOTAL_ == "total" & TRT01A == "Placebo"       N
#> 2:              TOTAL_ == "total" & TRT01A == "Placebo"       n
#> 3: TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"       N
#> 4: TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"       n
#> 5:                RACE == "WHITE" & TRT01A == "Placebo"       N
#> 6:                RACE == "WHITE" & TRT01A == "Placebo"       n
#> 7:   RACE == "WHITE" & TRT01A == "Xanomeline High Dose"       N
#> 8:   RACE == "WHITE" & TRT01A == "Xanomeline High Dose"       n
#>    stat_result_value
#>                <num>
#> 1:                69
#> 2:                 4
#> 3:                70
#> 4:                 1
#> 5:                63
#> 6:                 4
#> 7:                61
#> 8:                 1
```

Similarly, the number of combinations for many of the other 22 SOCs are
also less than the full 16 combinations:

``` r

table(ep_stat$endpoint_label)
#> 
#>                                                   AESOC: CARDIAC DISORDERS 
#>                                                                         12 
#>                          AESOC: CONGENITAL, FAMILIAL AND GENETIC DISORDERS 
#>                                                                         12 
#>                                         AESOC: EAR AND LABYRINTH DISORDERS 
#>                                                                         12 
#>                                                       AESOC: EYE DISORDERS 
#>                                                                          8 
#>                                          AESOC: GASTROINTESTINAL DISORDERS 
#>                                                                         16 
#>                AESOC: GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS 
#>                                                                         12 
#>                                             AESOC: HEPATOBILIARY DISORDERS 
#>                                                                          8 
#>                                             AESOC: IMMUNE SYSTEM DISORDERS 
#>                                                                          8 
#>                                         AESOC: INFECTIONS AND INFESTATIONS 
#>                                                                         12 
#>                      AESOC: INJURY, POISONING AND PROCEDURAL COMPLICATIONS 
#>                                                                         12 
#>                                                      AESOC: INVESTIGATIONS 
#>                                                                          8 
#>                                  AESOC: METABOLISM AND NUTRITION DISORDERS 
#>                                                                         12 
#>                     AESOC: MUSCULOSKELETAL AND CONNECTIVE TISSUE DISORDERS 
#>                                                                         12 
#> AESOC: NEOPLASMS BENIGN, MALIGNANT AND UNSPECIFIED (INCL CYSTS AND POLYPS) 
#>                                                                          8 
#>                                            AESOC: NERVOUS SYSTEM DISORDERS 
#>                                                                         16 
#>                                               AESOC: PSYCHIATRIC DISORDERS 
#>                                                                         12 
#>                                         AESOC: RENAL AND URINARY DISORDERS 
#>                                                                          8 
#>                            AESOC: REPRODUCTIVE SYSTEM AND BREAST DISORDERS 
#>                                                                          8 
#>                     AESOC: RESPIRATORY, THORACIC AND MEDIASTINAL DISORDERS 
#>                                                                         16 
#>                              AESOC: SKIN AND SUBCUTANEOUS TISSUE DISORDERS 
#>                                                                         16 
#>                                                AESOC: SOCIAL CIRCUMSTANCES 
#>                                                                          8 
#>                                     AESOC: SURGICAL AND MEDICAL PROCEDURES 
#>                                                                         12 
#>                                                  AESOC: VASCULAR DISORDERS 
#>                                                                          8
```
