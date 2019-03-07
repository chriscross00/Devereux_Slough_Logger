library(tidyverse)

setwd("D:/Documents/College/4th Year/Internships/Water Quality/Logger Data/180418 Logger Data/Conductivity")
con <- read.csv("180418_Conductivity.csv", header = F)

con <- con[3:1242,]
colnames(con) <- c("#", "date_time", "high_range", "temp")
y = as.POSIXlt(strptime(con$date, format = "%m/%d/%y %I:%M:%S %p"))
x = data.frame(con, newtime = y)
View(x)



x$high_range <- as.numeric(levels(x$high_range)[x$high_range])
x$temp <- as.numeric(levels(x$temp)[x$temp])

sapply(x, class)

ggplot(x, aes(newtime, temp)) +
  geom_line(na.rm = T) +
  scale_y_continuous(name = "Temperature (c)", breaks = seq(14, 28, 2)) + 
  scale_x_datetime(name = "Date", date_breaks = "2 day", date_labels = "%b %d")




temp.factor <- as.numeric(levels(x$temp))[x$temp]

temp.factor
sapply(temp.factor, class)

bay <- select(x, temp)
View(bay)
temp_ts <- ts(temp.factor, frequency = 96, start = 2018)
temp_ts



plot.ts(temp_ts)


