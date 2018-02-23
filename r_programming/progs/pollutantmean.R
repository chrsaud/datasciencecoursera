## Quiz 2
## Author: Chris Aud

## set working directory
setwd("C:/Users/Chris/Desktop/R Programming/quiz 2")

pollutantmean <- function(directory, pollutant, id = 1:332){
  
  ## retrieve current working directory to reset working directory at end of the function
  wd.curr <- getwd()
  
  ## set working directory to value of the directory variable
  setwd(directory)
  
  ## create empty base data frame
  base <- data.frame()
  
  ## read in all csvs specified in the id variable and bind into single dataframe
  for (i in id){
    
    ## read current csv
    data <- read.csv(paste0(sprintf("%03d", i),".csv"))
    
    ## bind current data to base data frame
    base <- rbind(base, data)
  }
  
  ## reset working directory to original
  setwd(wd.curr)
  
  ## calculate mean
  mean(base[[pollutant]], na.rm = TRUE)
}


