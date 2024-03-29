
<!-- README.md is generated from README.Rmd. Please edit that file -->

# R packages for AMNOG analyses

Ramnog is a collection of packages for setting up pipelines for
AMNOG-style HTA analyses

The aim of ramnog is that statistician/programmer can set up an
AMNOG-type analyses with minimal familiarity with R.

# Packages

<table class="table table-bordered table table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;background-color: lightblue !important;">
Package
</th>
<th style="text-align:left;background-color: lightblue !important;">
Description
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
[chef](https://hta-pharma.github.io/chef/)
</td>
<td style="text-align:left;">
Core package that aids in creating endpoint specifications, builds the
analysis pipeline, and coordinates the execution of the ananlyses
</td>
</tr>
<tr>
<td style="text-align:left;">
[chefStats](https://hta-pharma.github.io/chefStats/)
</td>
<td style="text-align:left;">
Collection of statistical methods that are used to make summarizations
or inferences for each endpoint/outcome
</td>
</tr>
<tr>
<td style="text-align:left;">
[chefCriteria]((https://hta-pharma.github.io/chefCriteria/))
</td>
<td style="text-align:left;">
Collection of criteria that are used in AMNOG dossiers to determin when
specific analyses/statistics should be calculated
</td>
</tr>
<tr>
<td style="text-align:left;">
[ramnog]((https://hta-pharma.github.io/ramnog/))
</td>
<td style="text-align:left;">
Wrapper package tying ecosystem together
</td>
</tr>
</tbody>
</table>

# Aim

The aim of the ramnog framework is that a programmer has to write
minimal code, and no programming to in order to set-up a new AMNOG-type
analyses. For each study, the programmer will need to make, adjust, or
check the following four types of code:

1.  The definition of each endpoint (or group of endpoints).
2.  A set of adam functions that makes any modifications to existing
    ADaM datasets (e.g., new age grouping in ADSL), or makes new ADaM
    datasets if none exist for the required output.
3.  (If needed) Define a set of criteria for when an endpoint should be
    included in the results. A library of these criteria are stored in
    the companion package {chefCriteria}
4.  A specification of the statistical functions used to
    summarize/analyze the data (usually found in the
    [chefStats](https://hta-pharma.github.io/chefStats/) package).

A core principal of the frameworks design is **modularity**. The core
functionality of the framework as specefied in the code in
[chef](https://hta-pharma.github.io/chef/) should change slowly, while
functionality that is subject to more frequent changes are sectioned off
in other packages ([chefStats](https://hta-pharma.github.io/chefStats/)
and [cheCriteria](https://hta-pharma.github.io/chefCriteria/))

# Contributing

We welcome contributions to the code base. Please see the [contributing
vignette](%22https://hta-pharma.github.io/chefCriteria/dev_git%22) for
more information on how to contribute.

# Installation

The packages are available to install from GitHub:

``` r
remotes::install_github("hta-pharma/ramnog")
```
