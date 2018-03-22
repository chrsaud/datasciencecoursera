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

## limit to only 2007-02-01 and 2007-02-02
data <- data[data$Date == "2007-02-01" | data$Date == "2007-02-02", ]

## create plot 1 histogram
hist(data$Global_active_power,
     breaks = 14,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")

## output to png file
dev.copy(png, "plot1.png")
dev.off()
