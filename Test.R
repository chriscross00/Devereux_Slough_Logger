library(ggplot2)
library(chron)
setwd("C:/Users/chris/Downloads/conductivity")
con = read.csv("180418_Conductivity.csv", header = TRUE, sep=",")
head(con)

#converts logger date and time into a readable format for R. Additional reading on this topic can be found here: http://biostat.mc.vanderbilt.edu/wiki/pub/Main/ColeBeck/datestimes.pdf
y = as.POSIXct(con$date, format = "%m/%d/%y %H:%M")
View(y)

#Adding our correctly formatted time. Note that we'll have both the unformatted time and the correctly formatted time on the same table.
x = data.frame(con, newtime = y)
View(x)
#Graph with our correctly formatted time and the conductivity. 
plot(x=x$newtime, y=x$conductivity, xlab="Date", ylab="Conductivty (mS/cm)", main="Conductivity at PIER", type="l")

#Just a graph of a couple days to see if daily trends exist.
plot(x=x$newtime[41:233], y=x$conductivity[41:233], type="l" ,xlab="Date", ylab="Conductivty (mS/cm)", main="Conductivity at PIER")


###We need to do a couple of things:
#1 Graph all the CSV onto 1 graphs.
#2 Graph DO and temperature.
