## Week 4 Programming Assigment - function to find hospital with user specified ranking
## in a state
## Author: Chris Aud

## set working directory
setwd("C:/Users/Chris/Desktop/datasciencecoursera/r_programming/data")

## find hospital with given ranking
rankall <- function(outcome, num) {
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  if (sum(c("heart attack", "heart failure", "pneumonia") == outcome) != 1){
    stop("invalid outcome")
  }
  
  ## convert outcome to a column index
  col.index <- cbind(c("heart attack", "heart failure", "pneumonia"), c(11,17,23))
  outcome.index <- as.numeric(col.index[,2][col.index[,1] == outcome])
  
  ## use outcome.index to select correct outcome column
  data.cols <- data[, c(2,7, outcome.index)]
  names(data.cols) <- c("hospital_name","State", "Outcome")
  
  ## convert outcome to numeric variable and remove NAs
  oldw <- getOption("warn")
  options(warn = -1)
  data.cols$Outcome <- as.numeric(data.cols$Outcome)
  data.cols <- data.cols[is.na(data.cols$Outcome)==FALSE,]
  options(warn = oldw)
  
  ## sort hospitals by outcome, state, name
  data.sort <- data.cols[order(data.cols[["State"]], data.cols[["Outcome"]],
                          data.cols[["hospital_name"]]), ]
  
  ## rank hospitals
  bestrank.list <- tapply(data.sort[["Outcome"]], 
                          data.sort[["State"]],
                          rank, ties.method = "first", simplify = TRUE)
  
  bestrank.df <- as.data.frame(unlist(bestrank.list))[, 1]
  

  data.sort$bestrank <- bestrank.df
  
  worstrank.list <- tapply(-data.sort[["Outcome"]], 
                           data.sort[["State"]],
                           rank, ties.method = "first", simplify = TRUE)
  
  worstrank.df <- as.data.frame(unlist(worstrank.list))[, 1]
  
  
  data.sort$worstrank <- worstrank.df
  
  ## control structure for output
  if (num == "best") {
    hospitals <- data.sort[data.sort$bestrank == 1,c(1:3)]
  } else if (num == "worst") {
    hospitals <- data.sort[data.sort$worstrank == 1,c(1:3)]
  } else {
    hospitals <- data.sort[data.sort$bestrank == num,c(1:3)]
  }
  
  ## create na rows for states with obs
  states <- as.data.frame(unique(data.sort$State), stringsAsFactors = FALSE)
  hospitals <- merge(states, hospitals, by.x=colnames(states), by.y="State", all.x = TRUE)
  names(hospitals) <- c("state", "hospital", gsub(" ", "_", outcome))
  hospitals
}

