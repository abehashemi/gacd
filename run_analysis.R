# Project Use HAR data at:
#		http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# 	You should create one R script called run_analysis.R that does the following. 
#	
# 1.   Merges the training and the test sets to create one data set.
# 2.   Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.   Uses descriptive activity names to name the activities in the data set
# 4.   Appropriately labels the data set with descriptive variable names. 
# 5.   From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Load necessary libraries:
library(dplyr)
library(data.table)
library(tidyr)
# Create project data directory, if none exists.
if(!file.exists("./pData")){dir.create("./pData")}
# set url
dUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Download zip file, then unzip
download.file(dUrl,destfile="./pData/pDs.zip")
dwnldT <- Sys.time()
unzip(zipfile="./pData/pDs.zip", exdir="./pData")
#lst <- list.files("./pData", recursive=TRUE)
# This data set contain 3 basic variables and each variable's values is partitioned into test and train subsets
# Subject (actor) : values are in subject_train.txt and subject_test.txt
# Activity: values are in Y_train.txt and Y_test.txt, level are in activity_labels.txt
# Features (measured) values are in X_train.txt and X_test.txt, and names are in featuress.txt.
# Read each file's data into workspace under proper variable:
	# Train Data Set
trainSubjectDs <- read.table("./pData/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
trainActivityDs <- read.table("./pData/UCI HAR Dataset/train/Y_train.txt", header = FALSE)
trainFeatureDs <- read.table("./pData/UCI HAR Dataset/train/x_train.txt", header = FALSE)
	# Test Data Set
testSubjectDs <- read.table("./pData/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
testActivityDs <- read.table("./pData/UCI HAR Dataset/test/Y_test.txt", header = FALSE)
testFeatureDs <- read.table("./pData/UCI HAR Dataset/test/x_test.txt", header = FALSE)
# 1.   Merges the training and the test sets to create one data set:
subjectDs <- rbind(trainSubjectDs, testSubjectDs)
activityDs <- rbind(trainActivityDs, testActivityDs)
featureDs <- rbind(trainFeatureDs, testFeatureDs)
# Set proper names to variables
names(subjectDs) <- c("subject")
names(activityDs) <- c("activity")
	#Read features
featureNames <- read.table("./pData/UCI HAR Dataset/features.txt", header = FALSE)
names(featureDs)<- featureNames$V2
# Combine columns into a single data frame
harDs <- cbind(subjectDs, activityDs)
harDs <- cbind(featureDs, harDs)
# 2.   Extracts only the measurements on the mean and standard deviation for each measurement:
selectFeatureDs <- grep("mean\\(\\)|std\\(\\)", featureNames$V2,value=TRUE) 
selectFeatureDs <- union(c("subject", "activity"), selectFeatureDs)
harDs<- subset(harDs, select=selectFeatureDs) 
# 3.   Uses descriptive activity names to name the activities in the data set:
	# Read activity labels
activityLabels<- tbl_df(read.table("./pData/UCI HAR Dataset/activity_labels.txt"))
names(activityLabels) <- c("activity","activityName")
harDs$activity <- factor(harDs$activity, labels=activityLabels$activityName)
# 4.   Appropriately labels the data set with descriptive variable names:
names(harDs)<-gsub("std()", "SD", names(harDs))
names(harDs)<-gsub("mean()", "MEAN", names(harDs))
names(harDs)<-gsub("^t", "time", names(harDs))
names(harDs)<-gsub("^f", "frequency", names(harDs))
names(harDs)<-gsub("Acc", "Accelerometer", names(harDs))
names(harDs)<-gsub("Gyro", "Gyroscope", names(harDs))
names(harDs)<-gsub("Mag", "Magnitude", names(harDs))
names(harDs)<-gsub("BodyBody", "Body", names(harDs))
# 5.   From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
harDs2<-aggregate(. ~subject + activity, harDs, mean)
harDs2<-harDs2[order(harDs2$subject,harDs2$activity),]
write.table(harDs2, file = "./pData/harMeanDs.txt",row.name=FALSE)