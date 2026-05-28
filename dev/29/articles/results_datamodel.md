# Result Data Model

The output from {chef} is a `data.table` containing the statistics for
each stratum within each endpoint based on the specified analysis data
for each endpoint.

The columns in the table contain information on six different
hierarchical levels, meaning that e.g. information on level 2 is a sub
level of level 1.

The table utilizes a long format structure, ensuring that each row
corresponds to the most granular level of information (level 6). This
level comprises individual statistical outcomes derived from the applied
statistical functions.

The six information levels in the output data from {chef} are:

1.  **Endpoint specification**. This may entail multiple endpoint
    specifications within the output.
2.  **Endpoint**. If a `group_by` argument is included in the endpoint
    specification, it will result in a set of endpoints for each group
    level within that specification. If group_by is absent, only a
    single endpoint will be generated.
3.  **Stratifier**. These are applied to each endpoint. For instance, if
    the stratifiers are `SEX` and `AGEGR`, the endpoint will be divided
    into three entities (one for each stratifier, and an additional one
    for the total, which is a unique, fixed stratification with a
    singular stratum).
4.  **Statistical function**. The R functions designated for application
    to each stratifier.
5.  **Stratum**. The levels of each stratifier.
6.  **Statistics**. The statistics corresponding to each stratum.

The table below describes all the columns in the output table. Note that
information on levels 1-5 may be repeated on several rows, since level 6
is the defining row level.

| Aggregation level | Column name | Type | Description |
|----|----|----|----|
| Level 1: Endpoint specification | `endpoint_spec_id` | int | Id of endpoint specification. |
|  | `study_metadata` | list | Study metadata. |
|  | `pop_var` | char | Population filter variable. |
|  | `pop_value` | char | Population filter value. |
|  | `treatment_var` | char | Treatment variable. |
|  | `treatment_refval` | char | Treatment reference value. |
|  | `period_var` | char | Period filter variable. |
|  | `period_value` | char | Period filter value. |
|  | `custom_pop_filter` | char | Custom (free text) population filter. |
|  | `endpoint_filter` | char | Endpoint filter expression. |
|  | `group_by` | list | List of variables to group by (cross combinations). |
|  | `stratify_by` | list | List of variables on which to stratify the analysis data. |
|  | `key_analysis_data` | char | Id of analysis data set (filtered by population filter). |
| Level 2: Endpoint | `empty` | logical | Indicates if the endpoint is empty (no events). |
|  | `endpoint_group_metadata` | list | Specification of group slice. |
|  | `endpoint_group_filter` | char | Filter expression to extract group slice from analysis data. |
|  | `endpoint_id` | char | Endpoint id. One endpoint per group slice. |
|  | `endpoint_label` | char | Endpoint label. |
|  | `event_index` | list | Indices (rows) in the analysis data that are events. |
|  | `crit_accept_endpoint` | logical | Evaluation of crit_endpoint. |
| Level 3: Stratifier | `strata_var` | char | Stratification variable. |
|  | `strata_id` | char | Id of stratifier. |
|  | `crit_accept_by_strata_by_trt` | logical | Evaluation of `crit_by_strata_by_trt`. |
|  | `crit_accept_by_strata_across_trt` | logical | Evaluation of `crit_by_strata_across_trt`. |
| Level 4: Statistical function | `fn_hash` | char | Id of stat function. |
|  | `fn_type` | char | Type of stat function (`stat_by_strata_by_trt`, `stat_by_strata_across_trt`, or `stat_across_strata_across_trt`). |
|  | `fn_name` | char | Name of stat function. |
|  | `fn_call_char` | char | Stat function parsing (name of stat function and arguments). |
|  | `fn_callable` | list | Stat function code. |
| Level 5: Stratum | `stat_empty` | logical | Indicates if stratum is empty (`cell_index` is empty). |
|  | `stat_metadata` | list | Specification of stratum. |
|  | `stat_filter` | char | Filter expression to extract stratum from analysis data. |
|  | `stat_result_id` | char | Id of statistics produced by stat function. |
|  | `cell_index` | list | Indices (rows) in the analysis data included in the stratum. |
| Level 6: Statistics | `stat_result_description` | char | Description of the statistics (returned from statistical function). |
|  | `stat_result_label` | char | Label to the statistics (returned from statistical function). |
|  | `stat_result_qualifiers` | char | Qualifiers to the statistics (returned from statistical function). |
|  | `stat_result_value` | num | The statistical value returned from the statistical function. |
