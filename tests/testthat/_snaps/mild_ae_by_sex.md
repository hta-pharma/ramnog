# Complex pipeline runs without errors

    Code
      ep_stat[, .(stat_filter, endpoint_group_filter, stat_result_label,
        stat_result_description, stat_result_qualifiers, stat_result_value)]
    Output
             stat_filter endpoint_group_filter stat_result_label
                  <char>                <char>            <char>
          1:        <NA>                  <NA>              <NA>
          2:        <NA>                  <NA>              <NA>
          3:        <NA>                  <NA>              <NA>
          4:        <NA>                  <NA>              <NA>
          5:        <NA>                  <NA>              <NA>
         ---                                                    
      29942:        <NA>                  <NA>              <NA>
      29943:        <NA>                  <NA>              <NA>
      29944:        <NA>                  <NA>              <NA>
      29945:        <NA>                  <NA>              <NA>
      29946:        <NA>                  <NA>              <NA>
             stat_result_description stat_result_qualifiers stat_result_value
                              <char>                 <char>             <num>
          1:                    <NA>                   <NA>                NA
          2:                    <NA>                   <NA>                NA
          3:                    <NA>                   <NA>                NA
          4:                    <NA>                   <NA>                NA
          5:                    <NA>                   <NA>                NA
         ---                                                                 
      29942:                    <NA>                   <NA>                NA
      29943:                    <NA>                   <NA>                NA
      29944:                    <NA>                   <NA>                NA
      29945:                    <NA>                   <NA>                NA
      29946:                    <NA>                   <NA>                NA

