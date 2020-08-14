
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dtverse <img src="dtverse_logo.png"  width="180px" align="right"/>

<!-- badges: start -->

<!-- badges: end -->

Built on the top of data.table, `dtverse` is a grammar of data
manipulation with data.table, providing a consistent a series of utility
functions that help you solve the most common data manipulation
challenges:

  - Select columns
  - Split one column to multiple columns based on patterns
  - Filter cases based on their values
  - Fill missing values
  - Summarize and reduces multiple values down to a single summary
  - Reshape `long to wide` or `wide to long`

## Installation

You can install from github:

``` r
install.packages("dtverse")
```

## Select columns

Select variables in a data table. You can also use predicate functions
like is.numeric to select variables based on their properties (e.g. 1:3
selects the first column to the third column).

``` r
library(dtverse)
library(data.table)
data("dt_dates")
dt_dates <- setDT(dt_dates)
dtverse::select_cols(dt_dates, c("Start_Date", "Full_name"))
#>    Start_Date      Full_name
#> 1: 2019-05-01     Joe, Smith
#> 2: 2019-08-04 Alex, Robinson
#> 3: 2019-07-05     David, Big
#> 4: 2019-07-04     Julia, Joe
#> 5: 2019-04-27  Jessa, Oliver
```

## Split a column

Split a column with its special pattern, and assign to multiple columns
respectively. For example, split full name column to first name and last
name column.

``` r
data("dt_dates")
library(data.table)
data("dt_dates")
dtverse::str_split_col(dt_dates,
              by_col = "Full_name",
              by_pattern = ", ",
              match_to_names = c("First Name", "Last Name"))
#>    Start_Date   End_Date      Full_name First Name Last Name
#> 1: 2019-05-01 2019-06-01     Joe, Smith        Joe     Smith
#> 2: 2019-08-04 2019-08-09 Alex, Robinson       Alex  Robinson
#> 3: 2019-07-05 2019-08-14     David, Big      David       Big
#> 4: 2019-07-04 2019-07-05     Julia, Joe      Julia       Joe
#> 5: 2019-04-27 2019-05-10  Jessa, Oliver      Jessa    Oliver
```

## Filter cases based on values

`filter_all()` is to return a data table with **ALL** columns (greater
than/ less than/ equal to) a desired value.

``` r
data("dt_values")
dtverse::filter_all(dt_values, operator = "l", .2)
#>            A1         A2          A3
#> 1: 0.05785895 0.12946847 0.087393370
#> 2: 0.01923819 0.01278740 0.098913282
#> 3: 0.05195276 0.19132992 0.106693512
#> 4: 0.05032699 0.14571596 0.078407153
#> 5: 0.05952578 0.14576162 0.111872945
#> 6: 0.18180095 0.03566878 0.047573949
#> 7: 0.10973857 0.14381518 0.001265888
```

`filter_any()` is to return a data table with **ANY** columns (greater
than/ less than/ equal to) a desired value.

``` r
data("dt_values")
dtverse::filter_any(dt_values, operator = "l", .1)
#>                A1          A2         A3
#>   1: 0.0005183129 0.785432329 0.33682885
#>   2: 0.5106083730 0.089597210 0.35534382
#>   3: 0.0140479084 0.754373487 0.68909671
#>   4: 0.0646897766 0.659908085 0.33536504
#>   5: 0.0864958912 0.824531891 0.67044835
#>  ---                                    
#> 258: 0.0368269614 0.781635831 0.68857844
#> 259: 0.4405581164 0.008710776 0.06723523
#> 260: 0.0147206911 0.600409490 0.68254910
#> 261: 0.0277955788 0.508650963 0.28767138
#> 262: 0.9901734111 0.890964948 0.09758119
```

Similarly, `filter_all_at()` is to return a data table with **ALL
selected** columns (greater than/ less than/ equal to) a desired value.

``` r
data("dt_values")
dtverse::filter_all_at(dt_values, operator = "l", .1, c("A1", "A2"))
#>            A1         A2         A3
#> 1: 0.01923819 0.01278740 0.09891328
#> 2: 0.01134451 0.04448781 0.83378764
#> 3: 0.05962021 0.04581089 0.60585367
#> 4: 0.06966295 0.08512458 0.67216791
#> 5: 0.04913060 0.08084439 0.53249534
#> 6: 0.03235521 0.08765999 0.71016331
```

Similarly, `filter_any_at()` is to return a data table with **ANY
selected** columns (greater than/ less than/ equal to) a desired value.

``` r
data("dt_values")
dtverse::filter_any_at(dt_values, operator = "l", .1, c("A1", "A2"))
#>                A1          A2         A3
#>   1: 0.0005183129 0.785432329 0.33682885
#>   2: 0.5106083730 0.089597210 0.35534382
#>   3: 0.0140479084 0.754373487 0.68909671
#>   4: 0.0646897766 0.659908085 0.33536504
#>   5: 0.0864958912 0.824531891 0.67044835
#>  ---                                    
#> 183: 0.0158175936 0.416905575 0.79278071
#> 184: 0.0368269614 0.781635831 0.68857844
#> 185: 0.4405581164 0.008710776 0.06723523
#> 186: 0.0147206911 0.600409490 0.68254910
#> 187: 0.0277955788 0.508650963 0.28767138
```

## Fill missing values

`fill_NA_with()` will fill NA value with a desired value in the selected
columns. If `fill_cols` is `All` (same columns type), it will apply to
the whole data table.

``` r
data("dt_missing")
dtverse::fill_NA_with(dt_missing, fill_cols = c("Full_name"), fill_value = "pending")
#>    Start_Date   End_Date     Full_name
#> 1:       <NA> 2019-06-01       pending
#> 2: 2019-08-04 2019-08-09       pending
#> 3: 2019-07-05 2019-08-14    David, Big
#> 4: 2019-07-04 2019-07-05    Julia, Joe
#> 5: 2019-04-27 2019-05-10 Jessa, Oliver
```

## Group by and summarize

`dt_group_by()` is to group by desired columns and summarize rows within
groups.

``` r
data("dt_groups")
print(head(dt_groups))
#>           A1        A2 group2 group1
#> 1: 0.6312317 0.5596497      1      1
#> 2: 0.9343597 0.8214651      2      2
#> 3: 0.1394824 0.7866118      3      3
#> 4: 0.8566525 0.1973685      4      4
#> 5: 0.9658633 0.6671387      5      5
#> 6: 0.4725889 0.3767837      1      6
```

Now we see the `dt_groups` data table has A1, A2 as numeric columns, and
group1, group2 as group infomation.

``` r
data("dt_groups")
dtverse::dt_group_by(dt_groups, 
            group_by_cols = c("group1", "group2"), 
            summarize_at = "A1", 
            operation = "mean")
#>     group1 group2 summary_col
#>  1:      1      1   0.4953336
#>  2:      2      2   0.4948892
#>  3:      3      3   0.5314195
#>  4:      4      4   0.4958035
#>  5:      5      5   0.4825304
#>  6:      6      1   0.5213521
#>  7:      7      2   0.5305957
#>  8:      8      3   0.4768201
#>  9:      9      4   0.4855223
#> 10:     10      5   0.5002411
```

Now we want to group by group1 and group2, then fetch the first within
each group, we can use `get_row_group_by()` function.

``` r
data("dt_groups")
dtverse::get_row_group_by(dt_groups, 
                 group_by_cols = c("group1", "group2"), 
                 fetch_row = "first")
#>     group1 group2        A1        A2
#>  1:      1      1 0.6312317 0.5596497
#>  2:      2      2 0.9343597 0.8214651
#>  3:      3      3 0.1394824 0.7866118
#>  4:      4      4 0.8566525 0.1973685
#>  5:      5      5 0.9658633 0.6671387
#>  6:      6      1 0.4725889 0.3767837
#>  7:      7      2 0.3530244 0.6344632
#>  8:      8      3 0.2041025 0.7531322
#>  9:      9      4 0.8718080 0.6506606
#> 10:     10      5 0.3357608 0.9362194
```

or last row with same example.

``` r
data("dt_groups")
dtverse::get_row_group_by(dt_groups, 
                 group_by_cols = c("group1", "group2"), 
                 fetch_row = "last")
#>     group1 group2         A1          A2
#>  1:      1      1 0.17294752 0.063375355
#>  2:      2      2 0.54620192 0.464936862
#>  3:      3      3 0.76486138 0.733507319
#>  4:      4      4 0.33303746 0.448011979
#>  5:      5      5 0.10455568 0.007968041
#>  6:      6      1 0.39483556 0.036755550
#>  7:      7      2 0.89792830 0.397020292
#>  8:      8      3 0.94427852 0.647780578
#>  9:      9      4 0.08840417 0.885425312
#> 10:     10      5 0.66508247 0.571804764
```

## Reshape `long to wide` or `wide to long`

Here is an example of reshaping a data table from wide to long.

``` r
data("dt_dates")
print(head(dt_dates))
#>    Start_Date   End_Date      Full_name First Name Last Name
#> 1: 2019-05-01 2019-06-01     Joe, Smith        Joe     Smith
#> 2: 2019-08-04 2019-08-09 Alex, Robinson       Alex  Robinson
#> 3: 2019-07-05 2019-08-14     David, Big      David       Big
#> 4: 2019-07-04 2019-07-05     Julia, Joe      Julia       Joe
#> 5: 2019-04-27 2019-05-10  Jessa, Oliver      Jessa    Oliver
dtverse::reshape_longer(dt_dates, 
               keep_cols = "Full_name", 
               by_pattern = "Date", 
               label_cols = c("Date_Type"), 
               value_cols = "Exact_date", 
               fill_NA_with = NULL)
#>          Full_name  Date_Type Exact_date
#>  1:     Joe, Smith Start_Date 2019-05-01
#>  2: Alex, Robinson Start_Date 2019-08-04
#>  3:     David, Big Start_Date 2019-07-05
#>  4:     Julia, Joe Start_Date 2019-07-04
#>  5:  Jessa, Oliver Start_Date 2019-04-27
#>  6:     Joe, Smith   End_Date 2019-06-01
#>  7: Alex, Robinson   End_Date 2019-08-09
#>  8:     David, Big   End_Date 2019-08-14
#>  9:     Julia, Joe   End_Date 2019-07-05
#> 10:  Jessa, Oliver   End_Date 2019-05-10
```

Here is an example of reshaping a data table from long to wide.

``` r
data("dt_long")
print(head(dt_long))
#>         Full_name  Date_Type Exact_date
#> 1:     Joe, Smith Start_Date 2019-05-01
#> 2: Alex, Robinson Start_Date 2019-08-04
#> 3:     David, Big Start_Date 2019-07-05
#> 4:     Julia, Joe Start_Date 2019-07-04
#> 5:  Jessa, Oliver Start_Date 2019-04-27
#> 6:     Joe, Smith   End_Date 2019-06-01
dtverse::reshape_wider(dt_long, 
              keep_cols = c("Full_name"), 
              col_lable = c("Date_Type"), 
              col_value = "Exact_date")
#>         Full_name Start_Date   End_Date
#> 1: Alex, Robinson 2019-08-04 2019-08-09
#> 2:     David, Big 2019-07-05 2019-08-14
#> 3:  Jessa, Oliver 2019-04-27 2019-05-10
#> 4:     Joe, Smith 2019-05-01 2019-06-01
#> 5:     Julia, Joe 2019-07-04 2019-07-05
```
