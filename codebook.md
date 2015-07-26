---
title: "harCodeBook"
author: "abe"
date: "Sunday, July 26, 2015"
output: html_document
---
 

For this derived dataset, these signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3D signals in the X, Y and Z axis.

    tBodyAcc-XYZ
    tGravityAcc-XYZ
    tBodyAccJerk-XYZ
    tBodyGyro-XYZ
    tBodyGyroJerk-XYZ
    tBodyAccMag
    tGravityAccMag
    tBodyAccJerkMag
    tBodyGyroMag
    tBodyGyroJerkMag
    fBodyAcc-XYZ
    fBodyAccJerk-XYZ
    fBodyGyro-XYZ
    fBodyAccMag
    fBodyAccJerkMag
    fBodyGyroMag
    fBodyGyroJerkMag

The set of variables that were estimated from these signals are:

    mean(): Mean value
    std(): Standard deviation

By averaging the signals in a signal window sample, additional angle() variables were calculated as:

    gravityMean
    tBodyAccMean
    tBodyAccJerkMean
    tBodyGyroMean
    tBodyGyroJerkMean

Other estimates have been removed.