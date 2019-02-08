ts\_test
================
Christopher Chan
February 7, 2019

<https://rpubs.com/hrbrmstr/time-series-machinations>

``` r
library(tidyverse)
library(here)
library(chron)
library(zoo)
library(xts)
```

Reading in a logger dataset that I've been using for testing.

``` r
here()

lv <- read_csv('180301 Level Data.csv')


lv$date_time <- as.POSIXct(lv$date_time, format = '%m/%d/%y %H:%M')
# lv$date_time <- format(lv$date_time, format = '%Y-%m-%d %H:%M')
str(lv)
```

Constructing the zoo class for our data. We are just starting out with water level.

``` r
lv_zoo <- zoo(lv$level_m, order.by = lv$date_time)

str(lv_zoo)
```

    ## 'zoo' series from 2018-02-12 12:00:00 to 2018-03-01 09:15:00
    ##   Data: num [1:1622] 2.19 2.19 2.19 2.19 2.2 ...
    ##   Index:  POSIXct[1:1622], format: "2018-02-12 12:00:00" "2018-02-12 12:15:00" ...

Checking to make sure all the data points are in the zoo class.

``` r
start(lv_zoo)
```

    ## [1] "2018-02-12 12:00:00 PST"

``` r
end(lv_zoo)
```

    ## [1] "2018-03-01 09:15:00 PST"

<https://datascienceplus.com/time-series-analysis-using-arima-model-in-r/>

Fitting an arima model to the data

``` r
lv_zoo <- data.frame(lv_zoo)

lv_zoo$ts <- as.POSIXct(rownames(lv_zoo), format = "%Y-%m-%d %H:%M:%S")


head(lv_zoo)
```

    ##                       lv_zoo                  ts
    ## 2018-02-12 12:00:00 2.191814 2018-02-12 12:00:00
    ## 2018-02-12 12:15:00 2.192614 2018-02-12 12:15:00
    ## 2018-02-12 12:30:00 2.187681 2018-02-12 12:30:00
    ## 2018-02-12 12:45:00 2.190214 2018-02-12 12:45:00
    ## 2018-02-12 13:00:00 2.196213 2018-02-12 13:00:00
    ## 2018-02-12 13:15:00 2.188881 2018-02-12 13:15:00

``` r
ggplot(lv_zoo, aes(ts, lv_zoo)) +
    geom_line()
```

![](ts_test_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
ggplot(lv, aes(date_time, level_m)) +
    geom_line()
```

![](ts_test_files/figure-markdown_github/unnamed-chunk-7-1.png)
