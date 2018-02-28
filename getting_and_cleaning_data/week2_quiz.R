## Getting and Cleaning Data - Week 2 Quiz
## Author: Chris Aud

## q1: what time was jtleek's datasharing repo created
## httr package allows easy connection to common APIs. httpuv handles http requests within the app
install.packages("httr")
install.packages("httpuv")
install.packages("jsonlite")

library(httr)
library(httpuv)
library(jsonlite)

## mostly taken from httr github tutorial

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at 
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "75d10fa85bb4a86172b1",
                   secret = "a74a435ec779fe87bd6473ee63accc4ee1d3a1cd")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

## converts http error to r error. should always be used when creating requests
## inside functions, so that user knows whay a request has failed
stop_for_status(req)

## view content of api request
cont <- content(req)

## reformat content using jsonlite
cont1 <- jsonlite::fromJSON(toJSON(cont))

## extract data sharing repo
ds_repo <- cont1[cont1$name == "datasharing", cont1$created_at]
ds_repo$created_at

##q2 download American Community Survey data. Use sqldf to select only data
## for probability weights pwgtp1 with ages less than 50

## install sqldf package
install.packages("sqldf")
library(sqldf)

## setwd
setwd("C:/Users/Chris/Desktop/datasciencecoursera/getting_and_cleaning_data")

## create empty csv file
file.create("data/quiz2_q2.csv")

## check that empty file exists
list.files("data")

## download data into empty file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", 
              destfile = "data/quiz2_q2.csv")

## read in
acs <- fread("data/quiz2_q2.csv")

## sql command to select only data for probability weights pwgtp1 with ages less than 50
sqldf("select pwgtp1 from acs where AGEP < 50")

## q3 using same data from previous question what is the equivalent of unique($AGEP)
sqldf("select distinct AGEP from acs")

## q4 How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
## http://biostat.jhsph.edu/~jleek/contact.html

library(XML)

## parse html from site
site <- htmlTreeParse("http://biostat.jhsph.edu/~jleek/contact.html", useInternal = TRUE)

## create output of character vectors
site_output <- capture.output(site)
nchar(site_output[c(10,20,30,100)]) ## this isn't a multiple choice answer, though seems like 
                                    ## a valid way to do it

## 2nd try
con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)

nchar(htmlCode[c(10,20,30,100)])

## q5 read a .for, fixed width file, into r and report sum of the numbers in the fourth column
## install readr package for read_fwf() function
install.packages("readr")
library(readr)

## read in for file
fwf <- read_fwf(
      file="https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for",   
      skip=4,
      fwf_widths(c(12, 7, 4, 9, 4, 9, 4, 9, 4)))

sum(fwf$X4)
