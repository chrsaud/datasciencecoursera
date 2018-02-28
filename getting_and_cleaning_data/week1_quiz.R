## JHU Getting and Cleaning Data - Week 1 Quiz
## Author: Chris Aud

## setwd
setwd("C:/Users/Chris/Desktop/datasciencecoursera/getting_and_cleaning_data")

## create data directory
dir.create(paste0(getwd(),"/data"))

##q1
setwd("data")

## create empty csv file
file.create(paste0(getwd(),"/quiz1_q1file.csv.csv"))

## check that empty file exists
list.files()

## download data into empty file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", 
              destfile = paste0(getwd(),"/quiz1_q1file.csv"))

## read csv into r
q1data <- read.csv("quiz1_q1file.csv")

## properties with greater than 1 mil value
sum(q1data[["VAL"]]==24, na.rm = TRUE)

## q3

## create empty xlsx file
file.create(paste0(getwd(),"/quiz1_q3file.xlsx"))
list.files()

## download data into empty file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", 
              destfile = paste0(getwd(),"/quiz1_q3file.xlsx"),
              mode = 'wb')

## read into r
## load excel library
library(xlsx)

dat <- read.xlsx("quiz1_q3file.xlsx", sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15)
sum(dat$Zip*dat$Ext,na.rm=T)

## q4
## load xml library
library(XML)
file_url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse("http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml",
                    useInternal = TRUE)

rootNode <- xmlRoot(doc)

## list zipcodes
zipcodes <- xpathSApply(rootNode,"//zipcode",xmlValue)

## count zipcodes equal to 21231
sum(zipcodes == 21231)

## q5
## install data.table package
install.packages("data.table")
library(data.table)

## create empty csv file
file.create(paste0(getwd(),"quiz1_q5file.csv"))

## check that empty file exists
list.files()

## download data into empty file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", 
              destfile = paste0(getwd(),"/quiz1_q5file.csv"))

## read csv into r
DT <- fread("quiz1_q5file.csv")

## check quickest method
system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)}) ## .04
system.time({sapply(split(DT$pwgtp15,DT$SEX),mean)}) ## not DT 
system.time({DT[,mean(pwgtp15),by=SEX]}) ## .02
system.time({tapply(DT$pwgtp15,DT$SEX,mean)}) ## 0
system.time({rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]}) ## error
system.time({mean(DT$pwgtp15,by=DT$SEX)}) ## 0
