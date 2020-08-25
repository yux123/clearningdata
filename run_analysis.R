# Getting and Cleaning Data Project JHU Coursera
# Author: Xiaobing Yu


## Load required package
library(dplyr)

## Download dataset
filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## Assign data frame
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Merge data
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

## Extract the measurement
TidYData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

## Use descriptive activity
TidYData$code <- activities[TidYData$code, 2]

## Appropriately labels the data
names(TidYData)[2] = "activity"
names(TidYData)<-gsub("Acc", "Accelerometer", names(TidYData))
names(TidYData)<-gsub("Gyro", "Gyroscope", names(TidYData))
names(TidYData)<-gsub("BodyBody", "Body", names(TidYData))
names(TidYData)<-gsub("Mag", "Magnitude", names(TidYData))
names(TidYData)<-gsub("^t", "Time", names(TidYData))
names(TidYData)<-gsub("^f", "Frequency", names(TidYData))
names(TidYData)<-gsub("tBody", "TimeBody", names(TidYData))
names(TidYData)<-gsub("-mean()", "Mean", names(TidYData), ignore.case = TRUE)
names(TidYData)<-gsub("-std()", "STD", names(TidYData), ignore.case = TRUE)
names(TidYData)<-gsub("-freq()", "Frequency", names(TidYData), ignore.case = TRUE)
names(TidYData)<-gsub("angle", "Angle", names(TidYData))
names(TidYData)<-gsub("gravity", "Gravity", names(TidYData))

## From the data set in step 4, creates a second
FinalData <- TidYData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

str(FinalData)

FinalData
