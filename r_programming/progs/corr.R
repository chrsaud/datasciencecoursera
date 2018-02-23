## Quiz 2
## Author: Chris Aud

## set working directory
setwd("C:/Users/Chris/Desktop/R Programming/quiz 2")

corr <- function(directory, threshold = 0){
  
  ## retrieve current working directory to reset working directory at end of the function
  wd.curr <- getwd()
  
  ## set working directory to value of the directory variable
  setwd(directory)
  
  ## create empty base data frame
  base <- vector()
  
  ## read in all csvs specified in the id variable and bind into single dataframe
  for (i in list.files()){
    
    ## read current csv
    data <- read.csv(i)
    
    ## count complete cases
    comp.cases <- sum(complete.cases(data) == TRUE)
    
    ## add complete cases count to base data frame
    if (comp.cases >= threshold) {
      corr <- cor(data[["nitrate"]], data[["sulfate"]], use = "na.or.complete", method = "pearson")
      base <- c(base, corr)
    }
  }
  
  ## reset working directory to original
  setwd(wd.curr)
  
  ## correlation in base
  print(base)
}

