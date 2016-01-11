Getting And Cleaning Data, Project Assignment
===================================

### Introduction

This repository holds the R code for the assignment of the Coursera Data Science Specialization track's "Getting and Cleaning Data" course.

The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

### Data Set

The data set "Human Activity Recognition Using Smartphones" has been taken from [UCI](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

### Analysis Procedure

The dataset should be downloaded before running the scripts in this repository. Download the dataset and place it in the `UCI HAR Dataset/` directory. In case dataset doesn't exist, the program is smart enough to download the dataset during runtime.

For successful execution, your directory structure must match the structure shown below:

```
your-working-dir/
 |
 |-UCI HAR Dataset/
 |  |-test/
 |  |-train/
 |  |-activity_labels.txt
 |  |-features.txt
 | 
 |-run_analysis.R 

```

The [`CodeBook.md`](https://github.com/akohli70/Getting And Cleaning Data/assignment/CodeBook.md) describes everything about the process that has been performed to clean up the data.

The `run_analysis.R` is the main script that performs the transformation. It can be loaded in R/Rstudio and executed without any parameters.

After successful execution of the script, the results are stored in the `tidy data` directory. The script creates one file (tidydata_all.txt) with values for activities.  The script also creates one tidy file per activity (LAYING.txt, SITTING.txt, STANDING.txt, WALKING.txt, WALKING_DOWNSTAIRS.txt, WALKING_UPSTAIRS.txt)
