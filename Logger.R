library(ggplot2)
library(chron)
setwd("D:/Documents/College/4th Year/Internships/Water Quality/Logger Data/180418 Logger Data/Conductivity")
con <- read.csv("180418_Conductivity.csv", header = F)
View(con)

con <- con[3:1242,]
colnames(con) <- c("#", "date_time", "high_range", "temp")
View(con)
#converts logger date and time into a readable format for R. Additional reading on this topic can be found here: http://biostat.mc.vanderbilt.edu/wiki/pub/Main/ColeBeck/datestimes.pdf
y = as.POSIXlt(strptime(con$date, format = "%m/%d/%y %I:%M:%S %p"))
View(y)

#Adding our correctly formatted time. Note that we'll have both the unformatted time and the correctly formatted time on the same table.
x = data.frame(con, newtime = y)
View(x)
#Graph with our correctly formatted time and the conductivity. 
plot(x=x$newtime, y=x$temp, xlab="Date", ylab="Conductivty (mS/cm)", main="Conductivity at PIER", type="l")



ggplot(x, aes(newtime, high_range)) +
  geom_line(na.rm = T)
  

#Just a graph of a couple days to see if daily trends exist.
plot(x=x$newtime[41:233], y=x$conductivity[41:233], type="l" ,xlab="Date", ylab="Conductivty (mS/cm)", main="Conductivity at PIER")


###We need to do a couple of things:
#1 Graph all the CSV onto 1 graphs.
#2 Graph DO and temperature.




