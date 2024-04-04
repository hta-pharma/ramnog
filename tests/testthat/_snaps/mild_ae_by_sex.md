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
      17108:                                                 <NA>
      17109:                                                 <NA>
      17110:                                                 <NA>
      17111:                                                 <NA>
      17112:                                                 <NA>
                                                                         endpoint_group_filter
                                                                                        <char>
          1: AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
          2: AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
          3: AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
          4: AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
          5: AESOC == "GENERAL DISORDERS AND ADMINISTRATION SITE CONDITIONS" & AESEV == "MILD"
         ---                                                                                  
      17108:                                                                              <NA>
      17109:                                                                              <NA>
      17110:                                                                              <NA>
      17111:                                                                              <NA>
      17112:                                                                              <NA>
             stat_result_label stat_result_description stat_result_qualifiers
                        <char>                  <char>                 <char>
          1:                 N      Number of subjects                   <NA>
          2:                 E        Number of events                   <NA>
          3:                 N      Number of subjects                   <NA>
          4:                 E        Number of events                   <NA>
          5:                 N      Number of subjects                   <NA>
         ---                                                                 
      17108:              <NA>                    <NA>                   <NA>
      17109:              <NA>                    <NA>                   <NA>
      17110:              <NA>                    <NA>                   <NA>
      17111:              <NA>                    <NA>                   <NA>
      17112:              <NA>                    <NA>                   <NA>
             stat_result_value
                         <num>
          1:                86
          2:                36
          3:                72
          4:                75
          5:                53
         ---                  
      17108:                NA
      17109:                NA
      17110:                NA
      17111:                NA
      17112:                NA

