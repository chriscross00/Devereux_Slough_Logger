library(ggplot2)

setwd("D:/Documents/College/4th Year/Internships/Water Quality/Logger Data/180131 Level Data")
Atmos = read.csv("180131 Level Data.csv", header=TRUE, sep=",")

View(Atmos)
plot(x=Atmos$date_time, y=Atmos$level_m, ylab="Height (m)", main="Devereux Slough Water Level (1/12/2018)")