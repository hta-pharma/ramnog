# Treatment Arms

## Overview

The treatment arm specifications are used to split the analysis data in
separate treatment arm that are assessed and compared in the endpoint.

In the endpoint specification the following two parameters must be set:

- **treatment_var**: Name of the variable in the analysis data set that
  contains the treatment arms.
- **treatment_refval**: The value of `treatment_var` that corresponds to
  the reference/intervention. This may be used for asymmetric statistics
  that compare the treatment effects.

## Examples

###### Ex 2.1

Here is an example of a partial endpoint specification with treatment
arm specifications:

``` r

# Example of endpoint specification of treatment arms.
ep_spec_ex2_1  <- chef::mk_endpoint_str(
  treatment_var = "TRT01A",
  treatment_refval = "Xanomeline High Dose",
  ...)
```
