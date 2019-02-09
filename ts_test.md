ts\_test
================
Christopher Chan
February 7, 2019

To do:

1.  Find out how to work with a non-stationary model
2.  Plot acf and pacf
    -   Determine the best model

<https://rpubs.com/hrbrmstr/time-series-machinations>

<https://datascienceplus.com/time-series-analysis-using-arima-model-in-r/>

``` r
library(tidyverse)
library(here)
library(chron)
library(zoo)
library(xts)
library(tseries)
library(forecast)
```

Reading in a logger dataset that I've been using for testing.

``` r
here()
lv <- read_csv('180301 Level Data.csv')

lv$date_time <- as.POSIXct(lv$date_time, format = '%m/%d/%y %H:%M')

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
cat('Absolute difference in water level over the period of', as.character(start(lv_zoo)), 'and', as.character(end(lv_zoo)), 'in meters:', max(lv_zoo) - min(lv_zoo))
```

    ## Absolute difference in water level over the period of 2018-02-12 12:00:00 and 2018-03-01 09:15:00 in meters: 0.06599439

Graphing the water level across time we see that the data is not stationary. A quick look at the graph and we can conclude that the mean decreases over time. Without further testing it is too hard to tell if the variance and covariance vary over time, but I believe they are relatively constant. These statitistical facts fit the ecological realities of Devereux Slough. Because of the very short rainy season, roughly \[X\] months, in Santa Barbara we would expect to see water level decrease in late winter.

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

![](ts_test_files/figure-markdown_github/unnamed-chunk-5-1.png)

``` r
series <- rnorm(300)
ggAcf(series)
```

![](ts_test_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
ggAcf(lv$level_m)
```

![](ts_test_files/figure-markdown_github/unnamed-chunk-6-2.png)

ggAcf(coredata(lv\_zoo)) ggPacf(lv\_zoo)

The ACF

acf(coredata(lv\_zoo)) pacf(coredata(lv\_zoo))

``` r
ggplot(lv, aes(date_time, level_m)) +
    geom_line()
```

![](ts_test_files/figure-markdown_github/unnamed-chunk-7-1.png)

Python links:

-   <https://machinelearningmastery.com/remove-trends-seasonality-difference-transform-python/>
-   <https://www.analyticsvidhya.com/blog/2018/09/non-stationary-time-series-python/>
