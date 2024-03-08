mk_advs <- function(study_metadata) {

  # Read ADSL
  adsl <- data.table::as.data.table(pharmaverseadam::adsl)

  # Filter treatment arms
  adsl <- adsl[adsl$TRT01A %in% c('Placebo', 'Xanomeline High Dose')]
  adsl[1,AGEGR1:=NA_character_]
  adsl[2:10,SEX:=NA_character_]

  # Read ADVS
  advs <- data.table::as.data.table(pharmaverseadam::advs)

  # Identify baseline body weight
  advs_bw <- advs[advs$PARAMCD == "WEIGHT" & advs$VISIT == "BASELINE"]

  # Create new variable BW_BASELINE
  advs_bw[["BW_BASELINE"]] <- advs_bw[["AVAL"]]

  # Merge ADSL, ADAE and baseline body weight from ADVS
  adam_out <-
    merge(adsl, advs_bw[, c("BW_BASELINE", "USUBJID")], by = "USUBJID", all.x = TRUE)

  return(adam_out)
}
