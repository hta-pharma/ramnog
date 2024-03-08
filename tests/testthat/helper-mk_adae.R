mk_adae <- function(study_metadata) {

  adsl <- pharmaverseadam::adsl |> data.table::setDT()

  adae <- pharmaverseadam::adae |> data.table::setDT()

  adae_out <-
    merge(adsl, adae[, c(setdiff(names(adae), names(adsl)), "USUBJID"), with =
                       F], by = "USUBJID", all = TRUE)

  adae_out[TRT01A %in% c('Placebo', 'Xanomeline High Dose'), ]
}
