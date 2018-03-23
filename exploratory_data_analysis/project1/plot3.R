## Exploratory Data Analysis Project 1
## Author: Chris Aud

# -------------------------------------------------- #
# set working directory and load necessary libraries #
# -------------------------------------------------- #

setwd("C:/Users/Chris/Desktop/ExData_Plotting1")
library(tidyr)
library(readr)
library(dplyr)

# ------------------------ #
# get zipped data from URL #
# ------------------------ #

temp <- tempfile()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(url,temp)

## decompress folder
unzip(temp)

## remove temp file
unlink(temp)

## read in data
data <- read_delim(file  = "household_power_consumption.txt",
                   delim = ";",
                   )

## convert Date to date format
data <- mutate(data, Date = as.Date(Date, "%d/%m/%Y"))

## combine date and time into one variable
data$datetime <- ymd_hms(paste(data$Date,data$Time))

## limit to only 2007-02-01 and 2007-02-02
data <- data[data$Date == "2007-02-01" | data$Date == "2007-02-02", ]

## turn on png device
png(filename = "plot3.png", width = 480, height = 480,
    units = "px", pointsize = 8, bg = "white", res = 120,
    restoreConsole = TRUE)

## create plot 3 line graph
plot(data$datetime,
     data$Sub_metering_1,
     type = "n",
     xlab = "",
     ylab = "Energy sub metering",
    )

legend("topright",
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       col = c("red","orange","blue"),
       lty = 1,
       lwd = 1
      )

lines(data$datetime, data$Sub_metering_1, col = "red")
lines(data$datetime, data$Sub_metering_2, col = "black")
lines(data$datetime, data$Sub_metering_3, col = "blue")

## turn off device
dev.off()


