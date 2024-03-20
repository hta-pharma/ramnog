# Complex pipeline runs without errors

    Code
      ep_stat[, .(stat_filter, endpoint_group_filter, stat_result_label,
        stat_result_description, stat_result_qualifiers, stat_result_value)]
    Output
                                                     stat_filter
                                                          <char>
         1:              TOTAL_ == "total" & TRT01A == "Placebo"
         2:              TOTAL_ == "total" & TRT01A == "Placebo"
         3: TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"
         4: TOTAL_ == "total" & TRT01A == "Xanomeline High Dose"
         5:                     SEX == "F" & TRT01A == "Placebo"
        ---                                                     
      4274:                                                     
      4275:                                                     
      4276:                                                     
      4277:                                                     
      4278:                                                     
                                                                                         endpoint_group_filter
                                                                                                        <char>
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
            stat_result_label           stat_result_description
                       <char>                            <char>
         1:                 N                Number of subjects
         2:                 E                  Number of events
         3:                 N                Number of subjects
         4:                 E                  Number of events
         5:                 N                Number of subjects
        ---                                                    
      4274:              <NA> P-value interaction not conducted
      4275:              <NA> P-value interaction not conducted
      4276:              <NA> P-value interaction not conducted
      4277:              <NA> P-value interaction not conducted
      4278:              <NA> P-value interaction not conducted
            stat_result_qualifiers stat_result_value
                            <char>             <num>
         1:                   <NA>                86
         2:                   <NA>                36
         3:                   <NA>                72
         4:                   <NA>                75
         5:                   <NA>                53
        ---                                         
      4274:                   <NA>                NA
      4275:                   <NA>                NA
      4276:                   <NA>                NA
      4277:                   <NA>                NA
      4278:                   <NA>                NA

