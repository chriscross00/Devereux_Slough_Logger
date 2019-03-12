Devereux Slough Time Series
================
Christopher Chan
February 17, 2019

To do: 1. Check residuals 2. Organize 3. Write-up

### Technologies used

-   RMarkdown
-   Libraries
    -   tidyverse
    -   forecast
-   Time series
    -   ACF and PACF
    -   Fourier transform
    -   ARIMA models

Introduction
============

Devereux Slough is a estuary in the Santa Barbara County. We developed Water Quality and Invertebrate Monitoring Program which collected samples from Devereux Slough. Water quality data was captured at regular intervals allowing us to build a time series model. This time series model can provide insights on how the estuary varies over time, while also predicting how the estuary might look in the future.

This project is broken down into the following steps:

1.  Background of Devereux Slough and data
2.  Normalizing the data
3.  EDA
4.  Creating the model
5.  Validating the model
6.  Forecasting
7.  Conclusion

This model serves several purposes. First, allows the COPR staff to more informed management descisions about the reserve and Devereux Slough. Collecting data and building models should result in better management of the reserve. Second, it extends the power of the COPR staff, allowing volunteers to contribute in meaningful ways with minimal effort from the COPR staff. Third, it can contribute to the larger scientific understanding of ecology. There is little scientific literature on TOCE in North America, most of the literature reflects TOCE in South Africa.

This project outlines a small portion of the Water Quality and Invertebrate Monitoring Program carried out by the Santa Barbarba Audubon Society, Coal Oil Point Reserve (COPR) and the Cheadle Center for Biodiversity and Ecological Restoration. More information about the Santa Barbara Audubon Society can be found [here](https://santabarbaraaudubon.org/), as well as COPR which can be found [here](https://copr.nrs.ucsb.edu/).

1 Background
============

### Introducion to Devereux Slough

Devereux Slough is a temporary closed/open estuary (TOCE) off of the Santa Barbara Channel. It is located within the COPR, a University of California Natural Reserve and managed by the University of California, Santa Barbara (UCSB). Along with the slough, COPR also manages Sands Beach which sits just meters away from Devereux Slough. This is thought to be a major source of water for the estury, though this has changed with the connection of Devereux Slough to North Campus Open Space (NCOS).

![](figures/DevereuxSloughAerialGoogleMaps.jpg)

A map of the Devereux Slough and the surrounding area

In general estuaries are 1 of the most productive aquatic systems in the world. Devereux Slough fits the definition of a temporary closed/open estuary. This means that for part of the year it is open to inputs of water and the rest of the year it is closed to inputs of water. Inputs of water in this context refers to bodies of watr and importantly exclude percipitation. For Devereux Slough it is closed for most of year, only open when it breaches during the winter, for a couple of days. This occurs when Devereux Slough fills up to a critical level from winter percipitation that water will flow over the sand berm and into Sands Beach, ultimately flowing into the Pacific Ocean. [Videos](https://www.youtube.com/watch?v=DVUcGfp0blE) of this event show just how violent flowing water can be.

A PhD thesis by Darcy Goodman examined Devereux Slough in a holistic sense, especially focussing on the fish diversity and management of the reserve. In addition to her thesis, Goodman estiblished a similar monitoring program, however that ended a couple years after starting. The lack of long-term ecological data is concerning on its own. However, with th recent major changes in the area, namely the connection of Devereux Slough to NCOS, monitoring Devereux Slough becomes more a of a pressing issue. We have already seen impacts to Devereux Slough from NCOS.

### Collection method

The Pier is one of three sites that we conducted consistently and is the deepest of all the sites, with consistent depths of over 1.5 meters. Data was collected via data loggers deployed off the Pier. The loggers recorded data every 15 minutes, which amounts to 96 data points per day. We retrieved the data and performed maintaince on the loggers every 2 weeks. This took roughly 2 hours, which explains some of the gaps in the data.

![](figures/FT-DevereuxSlough.jpg) A gorgeous picture of the Pier. Credits to the Santa Barbara Audubon Society

### Expected trends

Santa Barbara's climate is classified as a Mediterranean climate, characterized with warm, dry summers and mild winters. Little if any percipitation occurs outside of winter and annual percipitation is around 0.5 m per year. Because of this we can hypothesize some general water level trends. We would expect water level to be highest during the winters and decrease throughout the years, with the lowest points during the summer months, June through August.

``` r
library(tidyverse)
library(here)
library(forecast)
library(tseries)
```

2 Normalizing the data
======================

Things to add:

-   Create the msts

Reading in a logger dataset that I've been using for testing.

``` r
here()

lv <- read_csv('data/180301 Level Data.csv')
head(lv, n=5)
```

Changing the format of the date\_time column into a readible format by time series functions. We are using the zoo() over other time series functions, like the standard ts(), because it works well with irregular intervals.

``` r
lv$date_time <- as.POSIXct(lv$date_time, format = '%m/%d/%y %H:%M')
lv_df <- lv[c(2,5)]

cat('Absolute difference in water level over the period of', as.character(min(lv_df$date_time)), 'and', as.character(min(lv_df$date_time)), 'in meters:', max(lv_df$level_m) - min(lv_df$level_m))
```

    ## Absolute difference in water level over the period of 2018-02-12 12:00:00 and 2018-02-12 12:00:00 in meters: 0.06599439

3. EDA
======

Graphing the water level across time we gather a number of important insights into our data. The first is that the time series is not stationary. A quick look at the graph and we can conclude that the mean decreases over time. Without further testing it is too hard to tell if the variance and covariance vary over time, but I believe they are relatively constant. If the variance is constant than we can perform additive decomposition, this is where the seasonal variation is constant across time. A additive model is describe as: *T**i**m**e**s**e**r**i**e**s* = *S**e**a**s**o**n**a**l* + *T**r**e**n**d* + *R**a**n**d**o**m*

Second, it appears we have some seasonality, on a daily basis. This should be removed in order to get a accurate depiction of the trend of the series. These statistical facts fit the ecological realities of Devereux Slough. Because of the very short rainy season, roughly 3 months, in Santa Barbara we would expect to see water level decrease in late winter. Additionally, we should expect a annual seasonality, meaning that the water level will have a predictable cycle over the course of a year. We'll have to factor both the daily and annual seasonality into our time series model.

``` r
ggplot(lv_df, aes(date_time, level_m)) +
    geom_line() +
    geom_smooth(method = 'loess', se = FALSE) +
    xlab('Date') +
    ylab('Level (m)') + 
    ggtitle('Water level (m) over time')
```

![](devereux_slough_time_series_files/figure-markdown_github/unnamed-chunk-4-1.png)

This breaks down the data into it's individual components: seasonality, trend and the residuals, well irregular components using loess which gives the acronym STL. The seasonality seems to be daily and the amplitude does not seem to change, confirming a constant variance. This means we don't need to transform the amplitude, ie take the log. The trend is a relatively constant negative slope that occurs over the course of the dataset. The remainder, which are residuals from the seasonal plus trend fit, show no distinct pattern and are white noise. This means that all the data has been extracted from it and we have captured the entire picture.

While our time series has both daily and annual seasonality, we only run it with the daily seasonality because we don't have a entire annual seasonal cycle. stl() requires a entire cycle.

``` r
decomp_ts <- ts(lv_df$level_m, frequency = 96) %>%
    stl(s.window='periodic') %>%
    plot(main='Decomposition of level_m')
```

![](devereux_slough_time_series_files/figure-markdown_github/unnamed-chunk-5-1.png)

Because our decomposition plots show a negative trend we must make the time series stationary. This is done by taking the seasonal difference. The ACF and PACF before and after differencing are shown below. Because each day has 96 observations, our daily seasonal difference component is lag=96.A plot of the data after taking the seasonal difference shows that the trend is removed. Even after taking the seasonal difference there is significant autocorrelation with previous points. Now that the trend is removed from the dataset we can move on with our model.

``` r
ggtsdisplay(lv_df$level_m, main='ACF and PACF of level_m')
```

![](devereux_slough_time_series_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
ggtsdisplay(diff(lv_df$level_m, lag=96), main='ACF and PACF of diff(level_m)')
```

![](devereux_slough_time_series_files/figure-markdown_github/unnamed-chunk-6-2.png)

A more mathematically rigorous analysis of stationarity is the Augmented Dickey Fuller (ADF) Test. Running the ADF test on our data with daily seasonality taken into account gives us a p-value of less than 0.01. Because our p-value &gt; 0.05 we can reject our *H*<sub>0</sub> that there is a unit root in our time series, and accept the *H*<sub>1</sub> that the time series is stationary.

``` r
lv_adf <- adf.test(lv_df$level_m, k=96)
lv_diff_adf <- adf.test(diff(lv_df$level_m, lag=96), k=96)

cat('p-value from adf.test() of lv_df:', lv_adf$p.value)
```

    ## p-value from adf.test() of lv_df: 0.36561

``` r
cat('\np-value from adf.test() of seasonally differenced lv_df:', lv_diff_adf$p.value)
```

    ## 
    ## p-value from adf.test() of seasonally differenced lv_df: 0.01

4.Create the model
==================

Things to add:

-   ARIMA model
    -   Background
    -   equation
        *Y*<sub>*t*</sub> = *c* + *ϕ*<sub>1</sub>*y*<sub>*d**t* − 1</sub> + *ϕ*<sub>*p*</sub>*y*<sub>*d**t* − *p*</sub> + ... + *θ*<sub>1</sub>*ϵ*<sub>*t* − 1</sub> + *θ*<sub>*q*</sub>*ϵ*<sub>*t* − *q*</sub> + *ϵ*<sub>*t*</sub>
    -   Why i'm using this model
        -   Pros/Cons
-   Fourier transform
    -   Background
    -   Equation
    -   Why I need to use
-   msts object
    -   Explain why I need multiple seasonals

For this project we'll use a multi-seasonal time series (msts) function as our time series. This allows us to take into account the daily seasonality we've seen from the plots and the annual seasonality we'd expect to see based on meteorological reasoning. Since the loggers take measurements every 15 minutes we get our seasonal.period from the following equations:
4(measurements per hour) \* 24(hours in a day) = 96(measurements per day)
96(measurements per day) \* 365.25(days per year) = 35064(measurements per year)

Now that we have normalized our data and have time series object made we create a model.

``` r
lv_ts <- msts(lv$level_m, seasonal.periods=c(96,35064))
```

-   auto.arima
    -   analysis
    -   Ecological significance

``` r
arima_param <- function(ts){
    best_fit <- list(model=Inf, aicc=Inf, i=Inf, j=Inf)
    
    for (i in 1:10){
        for (j in 1:5){
            fit <- auto.arima(ts, seasonal=FALSE, xreg=fourier(ts, K=c(i,j)))
            if (fit$aicc < best_fit$aicc)
                best_fit <- list(model=fit, aicc=fit$aicc, i=i, j=j)
            else break;
        }
    
    }
    return(best_fit)
}
```

``` r
arima_model <- arima_param(lv_ts)

plotter <- forecast(arima_model$model, xreg=fourier(lv_ts, K=c(arima_model$i, arima_model$j), h=192))
autoplot(plotter)
```

![](devereux_slough_time_series_files/figure-markdown_github/unnamed-chunk-10-1.png)

5. Validate model
=================

-   Validate model
    -   looks
    -   residuals
        -   plot ACF, should not be correlated
        -   Ljung-box
        -   calculate mean and plot residuals

Running a Lijung-Box test to quantifiable determine if the ACF of lv\_diff is non-zero. Because the *H*<sub>0</sub> of the Box-Ljung test is that the data is independently distributed, rejecting the *H*<sub>0</sub> means that serial correlation exist in the data. Since the p-value &lt; 0.05, in this case it is less than 2.2e-16, we reject the *H*<sub>0</sub> and conclude the data has some serial correlation.

``` r
checkresiduals(arima_model$model, lag=96)
```

![](devereux_slough_time_series_files/figure-markdown_github/unnamed-chunk-11-1.png)

    ## 
    ##  Ljung-Box test
    ## 
    ## data:  Residuals from Regression with ARIMA(2,0,3) errors
    ## Q* = 70.722, df = 67, p-value = 0.3545
    ## 
    ## Model df: 29.   Total lags used: 96
