# Complex pipeline runs without errors

    Code
      ep_stat[, .(stat_filter, endpoint_group_filter, label, description, qualifiers,
        value)]
    Output
                                                     stat_filter
         1:              TOTAL_ == "total" & TRT01A == "Placebo"
         2: TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"
         3:              TOTAL_ == "total" & TRT01A == "Placebo"
         4: TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"
         5:                     SEX == "F" & TRT01A == "Placebo"
        ---                                                     
      4274:                                                     
      4275:                                                     
      4276:                                                     
      4277:                                                     
      4278:                                                     
                                                                                         endpoint_group_filter
         1:                  AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
         2:                  AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
         3:                  AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
         4:                  AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
         5:                  AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
        ---                                                                                                   
      4274:                                                AESOC == "SOCIAL CIRCUMSTANCES" & AESEV == "SEVERE"
      4275:                                         AESOC == "EAR AND LABYRINTH DISORDERS" & AESEV == "SEVERE"
      4276:                                         AESOC == "EAR AND LABYRINTH DISORDERS" & AESEV == "SEVERE"
      4277: AESOC == "NEOPLASMS BENIGN, MALIGNANT AND UNSPECIFIED (INCL CYSTS AND POLYPS)" & AESEV == "SEVERE"
      4278: AESOC == "NEOPLASMS BENIGN, MALIGNANT AND UNSPECIFIED (INCL CYSTS AND POLYPS)" & AESEV == "SEVERE"
            label                       description qualifiers value
         1:     E                  Number of events       <NA>    36
         2:     E                  Number of events       <NA>    75
         3:     N                Number of subjects       <NA>    86
         4:     N                Number of subjects       <NA>    72
         5:     E                  Number of events       <NA>    18
        ---                                                         
      4274:  <NA> P-value interaction not conducted       <NA>    NA
      4275:  <NA> P-value interaction not conducted       <NA>    NA
      4276:  <NA> P-value interaction not conducted       <NA>    NA
      4277:  <NA> P-value interaction not conducted       <NA>    NA
      4278:  <NA> P-value interaction not conducted       <NA>    NA

