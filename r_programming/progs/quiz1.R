## R Programming Week 1 Quiz ##
getwd()
setwd("../../downloads/quiz1_data")

dir <- getwd()

input_file <- paste0(dir,"/hw1_data.csv")

## read in data ##
quiz1_data <- read.csv(input_file,header=TRUE)
quiz1_data

## column names of data set
colnames(quiz1_data)

## first two rows ##
head(quiz1_data,2)

## last two rows ##
tail(quiz1_data,2)

## how many obs in dataset
nrow(quiz1_data)

## value of Ozone in 47th row ##
quiz1_data[47,"Ozone"]

## count missing values ##
sum(is.na(quiz1_data[["Ozone"]]))

## mean of the ozone column ##
## remove missing values
ozone_nomiss <- quiz1_data[["Ozone"]][is.na(quiz1_data[["Ozone"]]) == "FALSE"]
ozone_nomiss

## mean of ozone with na removed
mean(ozone_nomiss)

## Q18
solar_r_subset <- quiz1_data[["Solar.R"]][ (quiz1_data[["Ozone"]] > 31)  & (quiz1_data[["Temp"]] > 90)]

## remove NAs from solar_r_subset
solar_r_nomiss <- solar_r_subset[is.na(solar_r_subset) == "FALSE"]

## mean of solar.R with ozone over 31 and temp over 90
mean(solar_r_nomiss)

## Q19
subset <- quiz1_data[["Temp"]][quiz1_data[["Month"]] == 6]
mean(subset)

## Q20
max(quiz1_data[["Ozone"]][ (quiz1_data[["Month"]] == 5) & (is.na(quiz1_data[["Ozone"]])=="FALSE")])

head(quiz1_data)
quiz1_data$Ozone
quiz1_data[["Ozone"]]

columns <- "Ozone"
quiz1_data$columns
quiz1_data[[columns]]
