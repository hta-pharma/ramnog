# Endpoint Specification

## Overview

The endpoint specifications comprise a central input to {chef} as it
contains the instructions to produce the statistics for endpoints.

The specifications contain instructions on *what* data to use for the
endpoint, *what* statistics to include, *how* the statistics are
calculated, *how* to group the population, and *what* criteria must be
met to include the endpoint in the final dossier.

The specifications must be organized in a data table where each row
contains an endpoint specification These rows are processed
independently and may represent one of more endpoints. One single
specification may contain instructions to produce multiple endpoints for
e.g. different severity levels or system organ classes.

The result of processing the endpoint specifications through {chef} is a
set of statistics, which are structured in a long-formatted data table
that can be further processed by downstream modules that e.g. format the
raw results to endpoint tables. This is out of scope of {chef}.

Many of the components in the endpoint specifications consist of
references to custom functions outside {chef}, which provide high
flexibility in defining the endpoints. Both the endpoint specifications
and associated custom functions must be supplied by the user as inputs
to {chef} and is not a part of the package.

The endpoint definition is created by calling the function
`mk_endpoint_str`. Some endpoint parameters are required while others
are optional. Optional parameters are by default set to empty when
calling `mk_endpoint_str`, so that the user does not have to type all
endpoint parameters every time but only those that are required and
relevant to each endpoint specification.

In summary, the endpoint specifications can be considered a cooking
recipe that along with a set of ingredients (the trial data) and the
cooking tools (the custom functions) are handed over to the chef,
{chef}, that prepares the endpoints.

For more details on the internal steps of {chef} see [Getting Started
with
Pipelines](https://hta-pharma.github.io/ramnog/articles/targets_gettingstarted.md).

## Components

The parameters of each endpoint specification can be grouped in to the
sets below, which are explained in their respective sections:

| Type | Section | Argument name |
|:---|:---|:---|
| Population and outcome | [ADaM data](https://hta-pharma.github.io/ramnog/articles/ep_spec_adam_data.md). What data to use and how to consolidate it into a single data table for the endpoint that is used to calculate statistics. | `study_metadata` |
|  |  | `data_prepare` |
|  | [Treatment arms](https://hta-pharma.github.io/ramnog/articles/ep_spec_treatment_arms.md). Which variable contains marking of the treatment arms and what is the reference/intervention treatment arm. | `treatment_var` |
|  |  | `treatment_refval` |
|  | [Analysis population](https://hta-pharma.github.io/ramnog/articles/ep_spec_population_def.md). How to filter the data to the analysis population for the endpoint. | `pop_var` |
|  |  | `pop_value` |
|  |  | `custom_pop_filter` |
|  | [Endpoint events](https://hta-pharma.github.io/ramnog/articles/ep_spec_event_def.md). How to define events for the endpoint. | `period_var` |
|  |  | `period_value` |
|  |  | `endpoint_filter` |
|  |  | `group_by` |
|  | [Strata](https://hta-pharma.github.io/ramnog/articles/ep_spec_strata_def.md). How to slice the data within the endpoint. | `stratify_by` |
|  | [Endpoint label](https://hta-pharma.github.io/ramnog/articles/ep_spec_label.md). What events the endpoint describes. | `endpoint_label` |
|  | [Processing of strata without events](https://hta-pharma.github.io/ramnog/articles/ep_spec_strata_w_events.md). Specification of whether only strata levels with events are to be incorporated in the endpoint. | `only_strata_with_events` |
| Methods | [Criteria methods](https://hta-pharma.github.io/ramnog/articles/methods_criteria.md). Requirements that must be met to include different types of statistics in the endpoint results. | `crit_endpoint` |
|  |  | `crit_by_strata_by_trt` |
|  |  | `crit_by_strata_across_trt` |
|  | [Statistical methods](https://hta-pharma.github.io/ramnog/articles/methods_stat.md). Statistical methods to apply in the endpoint. | `stat_by_strata_by_trt` |
|  |  | `stat_by_strata_across_trt` |
|  |  | `stat_across_strata_across_trt` |
