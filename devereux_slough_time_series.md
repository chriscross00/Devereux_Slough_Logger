devereux\_slough\_time\_series
================
Christopher Chan
February 17, 2019

1.  Background of Devereux Slough and data
2.  Normalizing the data
3.  Creating the model
4.  Validating the model
5.  Forecasting
6.  Conclusion

Personal Outline:

1.  Introducion to DS
    -   Background of location Devereux Slough is a seasonally closed mouth estuary off the Santa Barbara Channel. It is located within the Coal Oil Point Reserve, a University of California Natural Reserve owened and managed by the University of California, Santa Barbara (UCSB). Along with the slough, the reserve also manages Sands Beach. This is thought to be a major source of water for the estury, though this has changed with the connection of Devereux Slough to North Campus Open Space (NCOS). A untested hypothesis is that Devereux Slough's daily water level changes are caused by tidal movements.
    -   Ecological importance
    -   Lack of previous research
2.  Introduction to data
    -   Collection method Data was collected via data loggers deployed off the Pier. The loggers recorded data every 15 minutes, which amounts to 96 data points per day. We retrieved the data and performed maintaince on the loggers every 2 weeks. This took roughly 2 hours, which explains some of the gaps in the data.
    -   Expected trends
3.  EDA data
    -   Plot of data with loess
4.  Stationarity
    -   ACF & PACF
    -   ADF and KPSS test
5.  Parameters of model
    -   Analyze ACF & PACF model
6.  Create model
7.  Validate model
8.  Forecast
9.  Conclusion
