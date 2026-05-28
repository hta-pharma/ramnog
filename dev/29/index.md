# ramnog

# R packages for AMNOG analyses

Ramnog is a collection of packages for setting up pipelines for
AMNOG-style HTA analyses

The aim of ramnog is that statistician/programmer can set up an
AMNOG-type analyses with minimal familiarity with R.

To get started, check out the [Quick
Start](https://hta-pharma.github.io/ramnog/articles/ramnog.md) guide

# Packages

| Package | Description |
|:---|:---|
| [chef](https://hta-pharma.github.io/chef/) | Core package that aids in creating endpoint specifications, builds the analysis pipeline, and coordinates the execution of the ananlyses |
| [chefStats](https://hta-pharma.github.io/chefStats/) | Collection of statistical methods that are used to make summarizations or inferences for each endpoint/outcome |
| [chefCriteria](https://hta-pharma.github.io/chefCriteria/) | Collection of criteria that are used in AMNOG dossiers to determin when specific analyses/statistics should be calculated |
| [ramnog](https://hta-pharma.github.io/ramnog/) | Wrapper package tying ecosystem together |

# Aim

The aim of {ramnog} is that a programmer has to write minimal code, and
no programming, to set-up a new AMNOG-type analyses.

For each study, the programmer will need to make, adjust, or check the
following four types of code:

1.  The definition of each endpoint (or group of endpoints).
2.  A set of ADaM functions that makes any modifications to existing
    ADaM datasets (e.g., new age grouping in ADSL), or makes new ADaM
    datasets if none exist for the required output.
3.  (If needed) Define a set of criteria for when an endpoint should be
    included in the results. A library of these criteria are stored in
    the companion package
    {[chefCriteria](https://hta-pharma.github.io/chefCriteria/)}.
4.  A specification of the statistical functions used to
    summarize/analyze the data. A library of these functions are
    provided in the
    {[chefStats](https://hta-pharma.github.io/chefStats/)} package.

A core principal of the frameworks design is **modularity**. The core
functionality of the framework resides in
{[chef](https://hta-pharma.github.io/chef/)} and should change slowly,
while functionality that is subject to more frequent changes are
sectioned off in other packages
({[chefStats](https://hta-pharma.github.io/chefStats/)} and
{[chefCriteria](https://hta-pharma.github.io/chefCriteria/)}).

# Contributing

We welcome contributions to the code base. Please see the [contributing
vignette](https://hta-pharma.github.io/ramnog/articles/dev_contribute.md)
for more information on how to contribute.

# Installation

The packages are available to install from GitHub:

``` r

remotes::install_github("hta-pharma/ramnog")
```
