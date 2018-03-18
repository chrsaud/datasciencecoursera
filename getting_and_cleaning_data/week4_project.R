## Getting and Cleaning Data Final Project
## Author: Chris Aud

# -------------------------------------------------- #
# set working directory and load necessary libraries #
# -------------------------------------------------- #

setwd("C:/Users/Chris/Desktop/datasciencecoursera/getting_and_cleaning_data/data")
library(tidyr)
library(readr)
library(dplyr)

# ------------------------ #
# get zipped data from URL #
# ------------------------ #

temp <- tempfile()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url,temp)

## decompress folder
unzip(temp)

## remove temp file
unlink(temp)

# ------------------- #
# load metadata files #
# ------------------- #

file <- "UCI HAR Dataset/activity_labels.txt"
labels <- read_table(file, delim = " ", col_names = FALSE)
names(labels) <- c("activity_key","activity_name")

## feature names
file <- "UCI HAR Dataset/features.txt"
features <- read_table(file, col_names = FALSE)
names(features) <- "feature_name"

## make character vector of feature names to use as column names in train/test data
## remove symbols
feature_labels <- gsub("[-()\\,]","",pull(features, feature_name))

## remove beginning numbers and space
feature_labels <- gsub("^[0-9]+ ","",feature_labels)


# ------------------------ #
# load training data files #
# ------------------------ #

## subjects
file <- "UCI HAR Dataset/train/subject_train.txt"
subject_train <- read_table(file, col_names = FALSE)
names(subject_train) <- "subject_num"

## key to link training data to activity labels
file <- "UCI HAR Dataset/train/y_train.txt"
y_train <- read_table(file, col_names = FALSE)
names(y_train) <- "activity_key"

## training data
file <- "UCI HAR Dataset/train/X_train.txt"
x_train <- read_table(file, col_names = FALSE)

## use feature labels vector as column names in x_train
names(x_train) <- feature_labels

## limit to only mean and standard deviation columns
x_train_limit <- x_train[, grepl("\\bmean()\\b|\\bstd()\\b", features$feature_name)]

## append subject id to training data
x_train_subject <- cbind(subject_train, x_train_limit)

## append activity key to training data
x_train_act_key <- cbind(y_train, x_train_subject)

## join activity labels on activity key
x_train_merge <- merge(x = labels, 
                       y = x_train_act_key, 
                       by.x = "activity_key", 
                       by.y = "activity_key", 
                       all.x = FALSE,
                       all.y = FALSE)

x_train_merge$group <- "train"

# -------------------- #
# load test data files #
# -------------------- #

## subjects
file <- "UCI HAR Dataset/test/subject_test.txt"
subject_test <- read_table(file, col_names = FALSE)
names(subject_test) <- "subject_num"

## key to link testing data to activity labels
file <- "UCI HAR Dataset/test/y_test.txt"
y_test <- read_table(file, col_names = FALSE)
names(y_test) <- "activity_key"

## testing data
file <- "UCI HAR Dataset/test/X_test.txt"
x_test <- read_table(file, col_names = FALSE)

## use feature labels vector as column names in x_test
names(x_test) <- feature_labels

## limit to only mean and standard deviation columns
x_test_limit <- x_test[, grepl("\\bmean()\\b|\\bstd()\\b", features$feature_name)]

## append subject id to testing data
x_test_subject <- cbind(subject_test, x_test_limit)

## append activity key to testing data
x_test_act_key <- cbind(y_test, x_test_subject)

## join activity labels on activity key
x_test_merge <- merge(x = labels, 
                       y = x_test_act_key, 
                       by.x = "activity_key", 
                       by.y = "activity_key", 
                       all.x = FALSE,
                       all.y = FALSE)

## add a variable to denote that this is test group
x_test_merge$group <- "test"

## append test set to training set
full_data <- rbind(x_train_merge, x_test_merge)

# ---------------------------------------------------------------------------- #
# create separate dataset with mean of every var for each subject and activity #
# ---------------------------------------------------------------------------- #

