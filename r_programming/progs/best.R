## Week 4 Programming Assigment - function to find best hospital in a state
## Author: Chris Aud

## set working directory
setwd("C:/Users/Chris/Desktop/datasciencecoursera/r_programming/data")

## load outcome dataset. this has data on quality of care measures
outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

## explore dataset 
str(outcome)

## histogram of 30 day death rates
outcome[, 11] <- as.numeric(outcome[,11])
hist(outcome[,11])

## find best hospital in the state
state <- "NY"
outcome <- "pneumonia"
best <- function(state, outcome) {
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  if (sum(unique(data$State) == state) != 1){
    stop("invalid state")
  }
  
  if (sum(c("heart attack", "heart failure", "pneumonia") == outcome) != 1){
    stop("invalid outcome")
  }
  
  ## Return hospital name in that state with lowest 30-day death
  ## convert outcome to a column index
  col.index <- cbind(c("heart attack", "heart failure", "pneumonia"), c(11,17,23))
  outcome.index <- as.numeric(col.index[,2][col.index[,1] == outcome])
  
  ## use outcome.index to select correct outcome column
  data.cols <- data[, c(2,7, outcome.index)]
  names(data.cols) <- c("hospital_name","State", "Outcome")

  ## limit to only the selected state
  data.limit <- data.cols[data.cols[["State"]] == state, ]
  
  ## convert outcome to numeric variable and remove NAs
  oldw <- getOption("warn")
  options(warn = -1)
  data.limit$Outcome <- as.numeric(data.limit$Outcome)
  data.limit <- data.limit[is.na(data.limit$Outcome)==FALSE,]
  options(warn = oldw)

  ## rate
  best.hospitals <- data.limit[data.limit[["Outcome"]]
                                == min(data.limit[["Outcome"]]),]
  

  best.hospital <- best.hospitals[best.hospitals[["hospital_name"]]
                                == min(best.hospitals[["hospital_name"]]), ]
  
  print(best.hospital)
}

