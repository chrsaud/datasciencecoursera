## Getting and cleaning data Quiz 4
## Author: Chris Aud

getwd()
setwd("C:/Users/Chris/Desktop/datasciencecoursera/getting_and_cleaning_data")
install.packages("readr")
library("readr")

## q1: Download the 2006 microdata survey about housing for the state of Idaho 
## Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
## What is the value of the 123 element of the resulting list?

file <- "data/idaho.csv"

## create empty csv for data
if (!file.exists(file)){
  file.create(file))
}

## url of data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

## download data
download.file(url, file)

## read in dataset
q1data <- read_csv(file)

## split the names of the data frame on wgtp. what is the 123 element?
strsplit(names(q1data), "wgtp")[[123]]

## q2: Load the Gross Domestic Product data for the 190 ranked countries in this data set
## Remove the commas from the GDP numbers in millions of dollars and average them. 
## What is the average?

file <- "data/gdp_q4.csv"

## create empty csv for data
if (!file.exists(file)){
  file.create(file)
}

## url of data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

## download data
download.file(url, file)

## read in dataset
q2data <- read_csv(file, skip = 6)

## keep only non-na columns
q2data <- q2data[, c(1,2,4,5)]

## rename columns
names(q2data) <- c("country", "rank", "countryName", "gdp")

## fix gdp variable
q2data$gdp <- as.numeric(gsub(",","", as.character(q2data$gdp)))

## remove unranked countries from GDP dataset
q2data$rank <- as.numeric(gsub(",","", as.character(q2data$rank)))
q2data <- q2data[is.na(q2data[["rank"]]) == FALSE,]

## mean of gdp
mean(q2data$gdp, na.rm = TRUE)

## q3: In the data set from Question 2 what is a regular expression that would allow 
## you to count the number of countries whose name begins with "United"?

## correct option: grep("United$Z", countryNames),3 because the carrot represents beginning of line
grep("^United", q2data$countryName, value = TRUE)

## q4: Load the educational data. Match the data based on the country shortcode. 
## Of the countries for which the end of the fiscal year is available, how many end in June?

file <- "data/education_q4.csv"

## create empty csv for data
if (!file.exists(file)){
  file.create(file)
}

## url of data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

## download data
download.file(url, file)

## read in dataset
q4data <- read_csv(file)

## merge q2 and q4 data
merge <- merge(x = q2data, 
               y = q4data, 
               by.x = "country", 
               by.y = "CountryCode", 
               all.x = FALSE,
               all.y = FALSE)

## countries with fical year end available
fy <- grep("Fiscal year end", merge[["Special Notes"]], value = TRUE)

## count of countries with fy end in june
length(grep("June", fy))

## q5: You can use the quantmod package to get historical stock prices for publicly 
## traded companies on the NASDAQ and NYSE. Download data on Amazon's stock price 
## and get the times the data was sampled.

install.packages("quantmod")
install.packages("lubridate")
library(quantmod)
library(lubridate)
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn)

## how many values were collected in 2012?
sum(year(sampleTimes) == 2012)

## how many values were collected in 2012 on Mondays?
sampleTimes2012 <- sampleTimes[year(sampleTimes) == 2012]
sum(wday(sampleTimes2012) == 2)
