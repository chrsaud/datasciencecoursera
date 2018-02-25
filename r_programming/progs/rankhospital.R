## Week 4 Programming Assigment - function to find hospital with user specified ranking
## in a state
## Author: Chris Aud

## set working directory
setwd("C:/Users/Chris/Desktop/datasciencecoursera/r_programming/data")

## find hospital with given ranking
rankhospital <- function(state, outcome, num) {
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
  
  ## sort hospitals by name
  data.sort <- data.limit[order(data.limit[["Outcome"]], data.limit[["hospital_name"]]), ]

  ## rank hospitals
  data.sort$rank <- rank(data.sort[["Outcome"]], ties.method = "first")
  
  ## control structure for output
  if (num == "best") {
    hospital <- data.sort[1, 1]
  } else if (num == "worst") {
    hospital <- data.sort[nrow(data.sort),1]
  } else {
    hospital <- data.sort[data.sort$rank == num, 1]
  }
  
  hospital
}

