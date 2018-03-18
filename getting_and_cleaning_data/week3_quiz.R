## Getting and Cleaning Data Week 3 Quiz
## Author: Chris Aud

## q1 - Download American Community Survey about US communities
## Create a logical vector that identifies households with > 10 acres
## and > 10k agricultural sales. Run which(agricultureLogical) and report first 3 values

file.create("acs_microdata.csv")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv",
              destfile = "acs_microdata.csv")

acs_microdata <- read.csv("acs_microdata.csv")

agricultureLogical <- acs_microdata[["ACR"]] == 3 & acs_microdata[["AGS"]] == 6

which(agricultureLogical)

## q2 - Load picture of instructor using the JPEG package. use parameter
## native = TRUE. what are the 30th and 80th quantiles of the data
install.packages("jpeg")

library(jpeg)

file.create("instructor.jpeg")
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg",
              destfile = "instructor.jpeg",
              mode = "wb")

jpeg <- readJPEG("instructor.jpeg", native = TRUE)

quantile(jpeg, probs = c(.3,.8))

## q3 - Load the Gross Domestic Product data for the 190 ranked countries
## and educational data. Match the data based on country shortcode. How
## many ids match? what is the 13th country in descending order by GDP?

file.create("gdp_data.csv"); file.create("education_data.csv")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
              destfile = "gdp_data.csv")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
              destfile = "educational_data.csv")

gdp <- read.csv("gdp_data.csv", 
                skip = 4
)

ed <- read.csv("educational_data.csv")

## clean gdp data
gdp <- gdp[,c(1,2,4,5)]

names(gdp) <- c("CountryCode", "Rank", "Country","GDP")

gdp$GDP <- as.numeric(gsub(",","", as.character(gdp$GDP)))

## remove unranked countries from GDP dataset
gdp$Rank <- as.numeric(gsub(",","", as.character(gdp$Rank)))
gdp <- gdp[is.na(gdp[["Rank"]]) == FALSE,]

## clean ed data
ed_narm <- ed[!is.na(ed$CountryCode),]

merge <- merge(x = gdp, 
               y = ed_narm, 
               by.x = "CountryCode", 
               by.y = "CountryCode", 
               all.x = FALSE,
               all.y = FALSE)

## num of matching ids
nrow(merge)

## 13th value in list
merge_sort <- merge[order(as.numeric(merge$Rank), decreasing = TRUE), ]
merge_sort[13,]

## q4: What is the average GDP Rank for the "High Income: OECD" and "High Income: NonOECD" group?
tapply(merge$Rank, merge$Income.Group, mean, na.rm = TRUE)

## q5: Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
##     are Lower middle income but among the 38 nations with highest GDP?

merge$QuantileGroup <- ntile(merge$Rank, 5)

table(merge$Income.Group, merge$QuantileGroup)
