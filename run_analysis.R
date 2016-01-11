## This program merges two data sets, calculates averages, and prepares tidy data

## define url for data download in case data doesn't exsist in the local working directory
data.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("./UCI HAR Dataset")) {
  dir.create("./UCI HAR Dataset")
  download.file(url = data.url, destfile="data.zip", method="curl")
  unzip(zipfile="data.zip")
  file.remove("data.zip")
}

## Ingest relevant data files in the sub-directory under the 
## Current working directory, named "UCI HAR Dataset"


## Read Feature Names and Activity Labels
feature_names <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)

## Read Training results, Subjects, and Labels
train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
## Read Training Subjects
train_subj <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
## Read Training Activities
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)

## Read Testing results, Subjects, and Labels
test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
## Read Test Subjects
test_subj <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
## Read Test Activities
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)

## Bind Subject, Activity, and Training Data
train <- cbind(train_subj, train_activity,train)

## Bind Subject, Activity, and Test Data
test <- cbind(test_subj, test_activity,test)

## Merge the train and test data
data <- rbind(train, test)

## Add column names with proper descriptors
feature_names <- append(c("subject", "activity"),as.vector(feature_names[,2]))
feature_names <- gsub("\\(\\)", "", feature_names)
feature_names <- gsub("[-,\\,]", ".", feature_names)
feature_names <- gsub("\\(", ".", feature_names)
feature_names <- gsub("\\)", "", feature_names)
feature_names <- gsub("BodyBody", "Body", feature_names)
names(data) <- feature_names

## Lookup Activity Label and update the merged data values
data$activity <- factor(data$activity, labels=as.vector(activity_labels[,2]))

## Extract Mean and SD values
datacolumns <- append(grep("mean", names(data), value=TRUE), grep("std", names(data), value=TRUE))
newdata <- data[, c("subject", "activity",datacolumns)]

## Calculate average of each variable for each activity and each subject
library(reshape2)
newdata <- melt(newdata, id=c("subject", "activity"))
newdata <- dcast(newdata, subject + activity ~ variable, mean)

## Split data per Activity
data_per_activity <- split(newdata,newdata$activity)

## Create Tidy Data directory
if (! dir.exists("tidy data")) {dir.create("tidy data", showWarnings=FALSE)}

## write all data in one file
write.table(newdata, file="tidy data/tidydata_all.txt", row.name=FALSE)

## Write Tidy Table per Activity
for (i in 1:length(data_per_activity)){
  write.table(data_per_activity[i],
            file=paste("tidy data/",names(data_per_activity[i]),".txt"),
            row.name = FALSE)
}
