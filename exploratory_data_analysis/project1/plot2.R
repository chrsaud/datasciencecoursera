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

## create plot 2 line graph
plot(data$datetime,
     data$Global_active_power,
     type = "n",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")

lines(data$datetime, data$Global_active_power)

## output to png
dev.copy(png, "plot2.png")
dev.off()
