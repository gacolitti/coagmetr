
# coagmetr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/gacolitti/coagmetr.svg?branch=master)](https://travis-ci.org/gacolitti/coagmetr)
[![Codecov test
coverage](https://codecov.io/gh/gacolitti/coagmetr/branch/master/graph/badge.svg)](https://codecov.io/gh/gacolitti/coagmetr?branch=master)
<!-- badges: end -->

`coagmetr` facilitates data fetching from [Colorado Climate Center Web
Services](https://coagmet.colostate.edu/cgi-bin/web_services.pl).

Currently, only CoAgMet daily, hourly, and five minute data is supported
(including daily and hourly soil moisture).

## Installation

``` r
# install.packages("devtools")
devtools::install_github("gacolitti/coagmetr")
```

## Examples

Station meta data:

``` r
library(coagmet)
get_coagmet_data("meta")
#> # A tibble: 115 x 8
#>    station_id station_name station_location latitude longitude elevation_ft
#>    <chr>      <chr>        <chr>               <dbl>     <dbl>        <dbl>
#>  1 akr02      Akron        USDA-ARS-GPRC        40.2     -103.         4537
#>  2 alt01      Ault         1 mi SE Ault         40.6     -105.         4910
#>  3 avn01      Avondale     1 mi SE Avondale     38.2     -104.         4630
#>  4 bla01      Blanca       8 mi SW Blanca       37.4     -106.         7755
#>  5 bnv01      Buena Vista  CDW Area SW of ~     38.8     -106.         7900
#>  6 brg01      Briggsdale   3 mi S Briggsda~     40.6     -104.         4858
#>  7 brk01      Bedrock      1 mile NE of Be~     38.3     -109.         4973
#>  8 brl01      Burlington ~ 18 mi NNE Burli~     39.5     -102.         3900
#>  9 brl02      Burlington ~ 6 mi SE Burling~     39.3     -102.         4170
#> 10 brl03      Burlington 3 4 mi NE of Burl~     39.3     -102.         4068
#> # ... with 105 more rows, and 2 more variables: data_logger_format <chr>,
#> #   active <chr>
```

Hourly data for all stations from January 1st, 2020 to current:

``` r
get_coagmet_data("hourly", start_date = "2020-01-01")
#> Warning: 76424 parsing failures.
#>  row  col           expected actual         file
#> 1237 st15 1/0/T/F/TRUE/FALSE -0.107 literal data
#> 1238 st15 1/0/T/F/TRUE/FALSE -0.204 literal data
#> 1239 st15 1/0/T/F/TRUE/FALSE -0.349 literal data
#> 1240 st15 1/0/T/F/TRUE/FALSE -0.538 literal data
#> 1241 st15 1/0/T/F/TRUE/FALSE -0.755 literal data
#> .... .... .................. ...... ............
#> See problems(...) for more details.
#> # A tibble: 84,553 x 17
#>    station_id datetime            tmean    rh    vp    sr    ws wind_vec
#>    <chr>      <dttm>              <dbl> <dbl> <dbl> <dbl> <dbl>    <dbl>
#>  1 akr02      2020-01-01 00:00:00 -7.50 0.769 0.268 0.006  2.36     248.
#>  2 akr02      2020-01-01 01:00:00 -6.7  0.749 0.277 0.006  2.95     256.
#>  3 akr02      2020-01-01 02:00:00 -5.16 0.691 0.288 0.005  3.64     264.
#>  4 akr02      2020-01-01 03:00:00 -6.17 0.715 0.275 0.005  3.28     257.
#>  5 akr02      2020-01-01 04:00:00 -6.03 0.684 0.266 0.006  3.16     255.
#>  6 akr02      2020-01-01 05:00:00 -4.01 0.594 0.27  0.007  3.60     258.
#>  7 akr02      2020-01-01 06:00:00 -3.03 0.56  0.274 0.006  4.52     265.
#>  8 akr02      2020-01-01 07:00:00 -3.74 0.625 0.290 0.012  2.58     244.
#>  9 akr02      2020-01-01 08:00:00 -1.30 0.593 0.329 2.31   4.56     271.
#> 10 akr02      2020-01-01 09:00:00  1.08 0.558 0.369 7.55   3.80     254.
#> # ... with 84,543 more rows, and 9 more variables: wind_std <dbl>,
#> #   pp <dbl>, st5 <dbl>, st15 <lgl>, gust <dbl>, gusttm <time>,
#> #   gustdir <dbl>, etr <dbl>, eto <dbl>
```
