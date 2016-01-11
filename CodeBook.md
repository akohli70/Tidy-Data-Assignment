### I. About

This file describes everything about the process that has been performed to clean up the data.

### II. Data Set Description

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

#### For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### III. Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

### IV. Process of Transforming the Data

#### 1. Load the data

The dataset must be stored in the `UCI HAR Dataset/` directory, under the current working directory.  If the dataset doesn't exist, the program will dowload it automatically.

The feature names and activity labels are read from the provided meta-data using the `read.table` function.

```
feature_names <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
```

Then we read in all the data, also using `read.table`.

```
train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
train_subj <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
test_subj <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
```

#### 2. Combining the data into one big table

The data read in the previous step is combined together to form a big dataset. The `rbind` and `cbind` functions are used to achieve this.

```
train <- cbind(train_subj, train_activity,train)
test <- cbind(test_subj, test_activity,test)
data <- rbind(train, test)
```

#### 3. Creating descriptive variable names

Each data frame of the data set is labeled (using the `features.txt`) with the information about the variables used on the feature vector. The `activity` and `subject` columns are also named in this step. The script also removes wanted characters.

```
feature_names <- append(as.vector(feature_names[,2]), c("subject", "activity"))
feature_names <- gsub("\\(\\)", "", feature_names)
feature_names <- gsub("[-,\\,]", ".", feature_names)
feature_names <- gsub("\\(", ".", feature_names)
feature_names <- gsub("\\)", "", feature_names)
feature_names <- gsub("BodyBody", "Body", feature_names)
names(data) <- feature_names
names(data) <- feature_names
```

#### 4. Extracting the relevant features

The features which are relevant in calculation of the mean and standard deviation are extracted using `grep`.

```
datacolumns <- append(grep("mean", names(data), value=TRUE), grep("std", names(data), value=TRUE))
newdata <- data[, c("subject", "activity",datacolumns)]
```

#### 5. Calulate Average

Load reshape2 Library for this function to work

The average of each variable for each activity and each subject is found using `dcast`.

```
newdata <- melt(newdata, id=c("subject", "activity"))
newdata <- dcast(newdata, subject + activity ~ variable, mean)
```

#### 6. Split Data Results by Activity
The data frame is split into levels per Activity
```
data_per_activity <- split(newdata,newdata$activity)
```


#### 7. Write the data to a file on disk

Finaly the desired means are written to a file on the disk using the `write.csv` function. 

The data is saved in the `tidy data` directory. The script creates one file (tidydata_all.txt) with values for activities.  The script also creates one tidy file per activity (LAYING.txt, SITTING.txt, STANDING.txt, WALKING.txt, WALKING_DOWNSTAIRS.txt, WALKING_UPSTAIRS.txt)

```
if (! dir.exists("tidy data")) {dir.create("tidy data", showWarnings=FALSE)}
write.table(newdata, file="tidy data/tidydata_all.txt", row.name=FALSE)
for (i in 1:length(data_per_activity))
    { write.table(data_per_activity[i], file=paste("tidy data/",names(data_per_activity[i]),".txt"),row.name = FALSE)
    }
```

