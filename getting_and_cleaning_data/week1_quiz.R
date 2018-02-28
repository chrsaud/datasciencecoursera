## JHU Getting and Cleaning Data - Week 1 Quiz
## Author: Chris Aud

## setwd
setwd("/nfs/analysis/analysis/kroger/cust_driven_supply_chain/ca")

## create directory for quiz
dir.create(paste0(getwd(),"/coursera"))

##q1

## create empty csv file
file.create(paste0(getwd(),"/coursera/dlfile.csv"))
setwd("coursera")

## check that empty file exists
list.files()

## download data into empty file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", 
              destfile = paste0(getwd(),"/dlfile.csv"))

## read csv into r
q1data <- read.csv("dlfile.csv")

## properties with greater than 1 mil value
sum(q1data[["VAL"]]==24, na.rm = TRUE)

## q3

## create empty xlsx file
file.create(paste0(getwd(),"/q3file.xlsx"))
list.files()
## download data into empty file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", 
              destfile = paste0(getwd(),"/q3file.xlsx"))

## read into r
## load excel library
library(xlsx)

dat <- read.xlsx("q3file.xlsx", sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15)
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
## create empty csv file
file.create(paste0(getwd(),"q5file.csv"))

## check that empty file exists
list.files()

## download data into empty file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", 
              destfile = paste0(getwd(),"/q5file.csv"))

## read csv into r
DT <- fread("q5file.csv")

## check quickest method
system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})
system.time({sapply(split(DT$pwgtp15,DT$SEX),mean)})
system.time({DT[,mean(pwgtp15),by=SEX]})
system.time({tapply(DT$pwgtp15,DT$SEX,mean)})
system.time({rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]})
system.time({mean(DT$pwgtp15,by=DT$SEX)})