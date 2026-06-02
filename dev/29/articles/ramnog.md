# Quick Start

In this vignette we start with an empty R project and walk through a
full working example analysis.

Our goal for this example analysis is to report the number of subjects
experiencing a mild adverse event in each treatment arm stratified by a
custom age grouping. For this example we use the ADAE dataset provided
in the {pharmaverseadam} package. To run this example you will need the
following packages installed:

- [chef](https://github.com/hta-pharma/chef)
- [chefStats](https://github.com/hta-pharma/chefStats)
- [pharmaverseadam](https://github.com/pharmaverse/pharmaverseadam)

The outline of the workflow will be:

1.  Set up our project infrastructure by running
    [`chef::use_chef`](https://hta-pharma.github.io/chef/reference/use_chef.html)
2.  Specify our endpoint
3.  Define function to produce our ADaM data
4.  Define function to calculate the statistics we want as results
    (i.e. number of events)
5.  Run the pipeline and inspect the results

## 1. Set up project infrastructure

**This assumes you have set up an RStudio project (or equivalent).** If
you have not done so, do that first.

To setup a chef project you need:

- A `R/` directory where all project-specific R code will be stored.
  This will include:
  - Any functions used to make the `ADaM` data ingested by the chef
    pipeline
  - The R function that produces the endpoint specification object
  - Any analysis/statistical functions that are not sourced from other R
    packages (like chefStats or chefCriteria)
  - A script containing
    [`library()`](https://rdrr.io/r/base/library.html) calls to any
    package needed for the pipeline to run
- A `pipeline/` directory where the `targets` pipeline(s) is/are defined
- A `targets.yml` file tracking the different pipelines

The file file structure should look like this:

    <R-project dir>/
        |-- R/
            |--- mk_endpoint_definition.R
            |--- mk_adam.R
            |--- packages.R
        |-- pipeline/
            |--- pipeline_01.R
        |-- _targets.yaml
        

{chef} has a convenience function to set up this infrastructure for you:

``` r

library(chef)
chef::use_chef(
  pipeline_id = "01"
)
```

This sets up the following file structure:

For now we need to know what the file in `R/` do. For the `_targets.yml`
and `pipeline_01.R` explanation, see `vignette("pipeline")`.

## 1. Specify an endpoint

Endpoint specifications need to be created inside a function, in this
case the function defined in the `mk_endpoint_definition.R`

An endpoint is created by using the
[`chef::mk_endpoint_str()`](https://hta-pharma.github.io/chef/reference/mk_endpoint_str.html)
function. For an explanation of how to specify endpoints, see
`vignette("endpoint_definitions")`.

Here we specify a minimal working endpoint based on the `adae` dataset
supplied by {pharmaverseadam}. We do this by modifying the
`R/mk_endpoint_definition.R` file so that is looks like this:

``` r

mk_endpoint_def <- function() {
  chef::mk_endpoint_str(
    study_metadata = list(),
    pop_var = "SAFFL",
    pop_value = "Y",
    treatment_var = "TRT01A",
    treatment_refval = "Xanomeline High Dose",
    stratify_by = list(c("AGEGR2")),
    data_prepare = mk_adae,
    endpoint_label = "A",
    custom_pop_filter = "TRT01A %in% c('Placebo', 'Xanomeline High Dose')",
    stat_by_strata_by_trt = list("N_subj_event" = c(chefStats::n_subj_event))
  )
}
```

You might notice a couple things with this specification:

- Even though we are using the ADAE dataset from {pharmavreseadam},
  there is no reference to this in the endpoint specification This is
  because the input clinical data is created via the `adam_fn` field, so
  in this case the reference to the `ADAE` data set will be inside the
  `mk_adae` function (see next section).
  - In the `stratify_by` field we refer to a variable called `AGEGR2`,
    however the ADAE dataset from {pharmaverseadam} does not contain any
    such variable. This is because we will derive this variable inside
    `mk_adae` (see next section).

## 2. Define the input dataset

We also need to provide chef with the `ADAE` input data set that that
corresponds to the endpoint specified above. To read more about make
these data sets, see `vignette("mk_adam")`. We can see that we have
strata based on a `AGEGR2`, which can be derived from the `AGE` variable
in `ADSL`. For now, we write a simple `ADaM` function `mk_adae` that
merges the `ADSL` data set (enriched with `AGEGR2`) onto the `ADAE` data
set, thereby creating the input data set.

``` r

mk_adae <- function(study_metadata) {
  adae <- data.table::as.data.table(pharmaverseadam::adae)
  adsl <- data.table::as.data.table(pharmaverseadam::adsl)
  adsl[, AGEGR2 := data.table::fcase(
    AGE < 70, "AGE < 70",
    AGE >= 70, "AGE >= 70"
  )]
  adae_out <-
    merge(adsl, adae[, c(setdiff(names(adae), names(adsl)), "USUBJID"),
      with =
        F
    ], by = "USUBJID", all = TRUE)
  adae_out[]
}
```

## 3. Define the analysis methods

Now that we have specified the endpoint to be analyzed, and defined the
analysis data set for {chef}, we need to define the analysis itself.

Our goal for this analysis is to count the number of events experiencing
an event. We need to define a function that makes those calculations,
and give that function to chef. Because we want a result per treatment
arm - strata combination, we must provide the function in the
`stat_by_strata_by_trt` argument in the endpoint specification. We have
already this argument set to
[`chefStats::n_subj_event`](https://hta-pharma.github.io/chefStats/reference/n_subj_event.html)
in the example endpoint specification above

## 4. Run the analysis pipeline

Now that all the inputs are defined, we can run the pipeline. This is
achieved by a call to
[`tar_make()`](https://docs.ropensci.org/targets/reference/tar_make.html)
from the {targets} package.

``` r

targets::tar_make()
```

Targets will show you which steps in the pipeline are executed and how
long each step took:

    ## Loading required package: targets
    ## 
    ## Attaching package: ‘data.table’
    ## 
    ## The following object is masked from ‘package:base’:
    ## 
    ##     %notin%
    ## 
    ## + ep dispatched
    ## ✔ ep completed [27ms, 514 B]
    ## + ep_id dispatched
    ## ✔ ep_id completed [9ms, 548 B]
    ## + ep_fn_map declared [1 branches]
    ## ✔ ep_fn_map completed [35ms, 326 B]
    ## + user_def_fn dispatched
    ## ✔ user_def_fn completed [3ms, 4.58 kB]
    ## + study_data dispatched
    ## ✔ study_data completed [45ms, 90.39 kB]
    ## + fn_map_tibble dispatched
    ## ✔ fn_map_tibble completed [4ms, 4.63 kB]
    ## + ep_and_data declared [1 branches]
    ## ✔ ep_and_data completed [13ms, 55.79 kB]
    ## + fn_map declared [1 branches]
    ## ✔ fn_map completed [1ms, 4.60 kB]
    ## + analysis_data_container declared [1 branches]
    ## ✔ analysis_data_container completed [1ms, 55.16 kB]
    ## + ep_with_data_key declared [1 branches]
    ## ✔ ep_with_data_key completed [0ms, 653 B]
    ## + ep_expanded declared [1 branches]
    ## ✔ ep_expanded completed [22ms, 502 B]
    ## + ep_event_index declared [1 branches]
    ## ✔ ep_event_index completed [5ms, 2.08 kB]
    ## + ep_crit_endpoint declared [1 branches]
    ## ✔ ep_crit_endpoint completed [9ms, 2.10 kB]
    ## + ep_crit_by_strata_by_trt declared [1 branches]
    ## ✔ ep_crit_by_strata_by_trt completed [10ms, 2.23 kB]
    ## + ep_crit_by_strata_across_trt declared [1 branches]
    ## ✔ ep_crit_by_strata_across_trt completed [5ms, 2.25 kB]
    ## + ep_prep_by_strata_across_trt declared [1 branches]
    ## ✔ ep_prep_by_strata_across_trt completed [2ms, 155 B]
    ## + ep_prep_across_strata_across_trt declared [1 branches]
    ## ✔ ep_prep_across_strata_across_trt completed [1ms, 155 B]
    ## + ep_prep_by_strata_by_trt declared [1 branches]
    ## ✔ ep_prep_by_strata_by_trt completed [44ms, 7.83 kB]
    ## + ep_rejected dispatched
    ## ✔ ep_rejected completed [0ms, 412 B]
    ## + ep_stat_by_strata_across_trt declared [1 branches]
    ## ✔ ep_stat_by_strata_across_trt completed [1ms, 136 B]
    ## + ep_stat_across_strata_across_trt declared [1 branches]
    ## ✔ ep_stat_across_strata_across_trt completed [1ms, 136 B]
    ## + ep_stat_by_strata_by_trt declared [1 branches]
    ## ✔ ep_stat_by_strata_by_trt completed [15ms, 3.41 kB]
    ## + ep_stat_nested dispatched
    ## ✔ ep_stat_nested completed [1ms, 3.37 kB]
    ## + ep_stat dispatched
    ## ✔ ep_stat completed [4ms, 3.31 kB]
    ## ✔ ended pipeline [956ms, 24 completed, 0 skipped]
    ## Warning messages:
    ## 1: A shallow copy of this data.table was taken so that := can add or remove 1 columns by reference. At an earlier point, this data.table was copied by R (or was created manually using structure() or similar). Avoid names<- and attr<- which in R currently (and oddly) may copy the whole data.table. Use set* syntax instead to avoid copying: ?set, ?setnames and ?setattr. It's also not unusual for data.table-agnostic packages to produce tables affected by this issue. If this message doesn't help, please report your use case to the data.table issue tracker so the root cause can be fixed or this message improved. 
    ## 2: 1 targets produced warnings. Run targets::tar_meta(fields = warnings, complete_only = TRUE) for the messages.

Then, to see the results, you load the cached step of the pipeline
corresponding to the results. In our case it will be `ep_stat`, so to
load it into the sessions as an object we call

``` r

targets::tar_load(ep_stat)
```

Now `ep_stat` is an R object like any other. Thus we can look at our
results simply by running

    ep_stat

However, there is a lot of extra data included in the object, so lets
look at a column subsection of the first 5 rows:

``` r

ep_stat[, .(
  treatment_var,
  treatment_refval,
  strata_var,
  stat_filter,
  stat_result_label,
  stat_result_description,
  stat_result_qualifiers,
  stat_result_value
)] |> head()
```

    ##    treatment_var     treatment_refval strata_var
    ##           <char>               <char>     <char>
    ## 1:        TRT01A Xanomeline High Dose     TOTAL_
    ## 2:        TRT01A Xanomeline High Dose     TOTAL_
    ## 3:        TRT01A Xanomeline High Dose     AGEGR2
    ## 4:        TRT01A Xanomeline High Dose     AGEGR2
    ## 5:        TRT01A Xanomeline High Dose     AGEGR2
    ## 6:        TRT01A Xanomeline High Dose     AGEGR2
    ##                                                 stat_filter stat_result_label
    ##                                                      <char>            <char>
    ## 1:                  TOTAL_ == "total" & TRT01A == "Placebo"                 n
    ## 2:     TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"                 n
    ## 3:               AGEGR2 == "AGE < 70" & TRT01A == "Placebo"                 n
    ## 4:              AGEGR2 == "AGE >= 70" & TRT01A == "Placebo"                 n
    ## 5:  AGEGR2 == "AGE < 70" & TRT01A == "Xanomeline High Dose"                 n
    ## 6: AGEGR2 == "AGE >= 70" & TRT01A == "Xanomeline High Dose"                 n
    ##           stat_result_description stat_result_qualifiers stat_result_value
    ##                            <char>                 <char>             <num>
    ## 1: Number of subjects with events                   <NA>                86
    ## 2: Number of subjects with events                   <NA>                72
    ## 3: Number of subjects with events                   <NA>                22
    ## 4: Number of subjects with events                   <NA>                64
    ## 5: Number of subjects with events                   <NA>                18
    ## 6: Number of subjects with events                   <NA>                54

## 5. Pass the data on to TFL formatting

Now that the data is produced, you can pass it on for TFL formatting
(outside the scope of {chef}).
