Devereux Slough Time Series
================
Christopher Chan
February 17, 2019

Introduction
============

Devereux Slough is a estuary in the Santa Barbara County. We developed Water Quality and Invertebrate Monitoring Program which collected samples from Devereux Slough. Water quality data was captured at regular intervals allowing us to build a time series model. This time series model can provide insights on how the estuary varies over time, while also predicting how the estuary might look in the future.

This project is broken down into the following steps:

1.  Background of Devereux Slough and data
2.  Normalizing the data
3.  Creating the model
4.  Validating the model
5.  Forecasting
6.  Conclusion

This model serves several purposes. First, allows the COPR staff to more informed management descisions about the reserve and Devereux Slough. Collecting data and building models should result in better management of the reserve. Second, it extends the power of the COPR staff, allowing volunteers to contribute in meaningful ways with minimal effort from the COPR staff. Third, it can contribute to the larger scientific understanding of ecology. There is little scientific literature on TOCE in North America, most of the literature reflects TOCE in South Africa.

This project outlines a small portion of the Water Quality and Invertebrate Monitoring Program carried out by the Santa Barbarba Audubon Society, Coal Oil Point Reserve (COPR) and the Cheadle Center for Biodiversity and Ecological Restoration. More information about the Santa Barbara Audubon Society can be found [here](https://santabarbaraaudubon.org/), as well as COPR which can be found [here](https://copr.nrs.ucsb.edu/).

1 Background
============

### Introducion to Devereux Slough

Devereux Slough is a temporary closed/open estuary (TOCE) off of the Santa Barbara Channel. It is located within the COPR, a University of California Natural Reserve and managed by the University of California, Santa Barbara (UCSB). Along with the slough, COPR also manages Sands Beach which sits just meters away from Devereux Slough. This is thought to be a major source of water for the estury, though this has changed with the connection of Devereux Slough to North Campus Open Space (NCOS).

![A map of the Devereux Slough and the surrounding area](figures/DevereuxSloughAerialGoogleMaps.jpg)

In general estuaries are 1 of the most productive aquatic systems in the world. Devereux Slough fits the definition of a temporary closed/open estuary. This means that for part of the year it is open to inputs of water and the rest of the year it is closed to inputs of water. Inputs of water in this context refers to bodies of watr and importantly exclude percipitation. For Devereux Slough it is closed for most of year, only open when it breaches during the winter, for a couple of days. This occurs when Devereux Slough fills up to a critical level from winter percipitation that water will flow over the sand berm and into Sands Beach, ultimately flowing into the Pacific Ocean. [Videos](https://www.youtube.com/watch?v=DVUcGfp0blE) of this event show just how violent flowing water can be.

A PhD thesis by Darcy Goodman examined Devereux Slough in a holistic sense, especially focussing on the fish diversity and management of the reserve. In addition to her thesis, Goodman estiblished a similar monitoring program, however that ended a couple years after starting. The lack of long-term ecological data is concerning on its own. However, with th recent major changes in the area, namely the connection of Devereux Slough to NCOS, monitoring Devereux Slough becomes more a of a pressing issue. We have already seen impacts to Devereux Slough from NCOS.

### Collection method

The Pier is one of three sites that we conducted consistently and is the deepest of all the sites, with consistent depths of over 1.5 meters. Data was collected via data loggers deployed off the Pier. The loggers recorded data every 15 minutes, which amounts to 96 data points per day. We retrieved the data and performed maintaince on the loggers every 2 weeks. This took roughly 2 hours, which explains some of the gaps in the data.

![A gorgeous picture of the Pier. Credits to the Santa Barbara Audubon Society](figures/FT-DevereuxSlough.jpg)

### Expected trends

Santa Barbara's climate is classified as a Mediterranean climate, characterized with warm, dry summers and mild winters. Little if any percipitation occurs outside of winter and annual percipitation is around 0.5 m per year. Because of this we can hypothesize some general water level trends. We would expect water level to be highest during the winters and decrease throughout the years, with the lowest points during the summer months, June through August.

``` r
library(tidyverse)
library(here)
library(zoo)
library(tseries)
library(forecast)
```

2 Normalizing the data
======================

Reading in a logger dataset that I've been using for testing.

``` r
here()
lv <- read_csv('data/180301 Level Data.csv')

lv$date_time <- as.POSIXct(lv$date_time, format = '%m/%d/%y %H:%M')

head(lv)
```

1.  EDA data
    -   Plot of data with loess
2.  Stationarity
    -   ACF & PACF
    -   ADF and KPSS test
3.  Parameters of model
    -   Analyze ACF & PACF model
4.  Create model
    -   Why i'm using this model
        -   Pros/Cons
5.  Validate model
6.  Forecast
7.  Conclusion
