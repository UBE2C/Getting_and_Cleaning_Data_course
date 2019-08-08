---
title: "CodeBook.md"
output:
  word_document: default
  html_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

##The dataset
The original dataset for this project was obtained from the following link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

As part of the "Getting and cleaning data" course, the two parts of the original datasets "test" and "train" were combined together (using a simple rbind() function), then reformatted and renamed and (hopefully) tidied up according to instructions, resulting in the new, tidy data named "x_tidy.txt".

In this CodeBook you will find:
  - the short description of the original data, copied from the original "features_info.txt" and "README.txt documents (download the data from the above link to see this file).
  - a short description of the steps taken during data processing (for longer description and script information please see the README.md file)
  - the names of the variables found in the new dataset
  - the full name of the activities found in the "Activities" column
  
I hope this codebook will make sense as you read along, and sorry for the typos (again) :).


##The original data (description copied directly from the original "README.txt")
Title:
Human Activity Recognition Using Smartphones Dataset
Version 1.0

Autors:
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.

Experimental description:
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 


##Data transformation
First the two data sets "test" and "train" were downloaded using the above mentioned link and read in into R as separate dataframes. The new combined data was supplemented by a new variable called "Dataframe_id" to track which observation came from which dataframe. The id numbers are the following: Dataframe_id 1 = "test" and Dataframe_id 2 = "train"

Next the two data frames were combined and split again by subsetting every variable containing the mean() or std() value.

Following subsetting the matching variable names were attached to the subsetted dataframe. Additionally the subsetted dataframe was supplemented by two new variables: "Subject_id" and "Activity".
The "Subject_id" variable marks the subject whose activity was measured, while the "Activity" variable describes the activity which was performed during measurment.

Next the "Dataframe_id", "Subject_id", and "Activity" variables were grouped and the mean value was calculated for all the other variables, broken down by subjects and activities. To make the resulting dataframe more compact and readable, the values were re-formatted to a scientific format.

Finally the resulting "tidy_x" dataframe was saved as "tidy_x.txt", using a tabular separator (sep = "\t").


##Variable names (the main description and variable names were copied from the original "features_info.txt" with slight changes)

Note: I did not make sweeping changes to the original variable names, as I find them and their description quite good and logical.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals timeAcc-XYZ and timeGyro-XYZ. These time domain signals (prefix 'time') were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (timeBodyAcc-XYZ and timeGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (timeBodyAccJerk-XYZ and timeBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (timeBodyAccMag, timeGravityAccMag, timeBodyAccJerkMag, timeBodyGyroMag, timeBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing freqBodyAcc-XYZ, freqBodyAccJerk-XYZ, freqBodyGyro-XYZ, freqBodyAccJerkMag, freqBodyGyroMag, freqBodyGyroJerkMag. (Note the 'freaq' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

Then these variables were used to estimate the mean and std value of the measured signals. Then these mean and std variables were subsetted and an avarage was calculated to each variable broken down by subject and activity.

Note: the 'mean()' indicates the average which were estimated from these signals.

timeBodyAcc-mean()-XYZ
timeGravityAcc-mean()-XYZ
timeBodyAccJerk-mean()-XYZ
timeBodyGyro-mean()-XYZ
timeBodyGyroJerk-mean()-XYZ
timeBodyAccMag-mean()
timeGravityAccMag-mean()
timeBodyAccJerkMagmean()
timeBodyGyroMag-mean()
timeBodyGyroJerkMag-mean()
freqBodyAcc-mean()-XYZ
freqBodyAccJerk-mean()-XYZ
freqBodyGyro-mean()-XYZ
freqBodyAccMag-mean()
freqBodyAccJerkMag-mean()
freqBodyGyroMag-mean()
freqBodyGyroJerkMag-mean()

Note: the 'std()' indicates the standard deviation which were estimated from these signals

timeBodyAcc-std()-XYZ
timeGravityAcc-std()-XYZ
timeBodyAccJerk-std()-XYZ
timeBodyGyro-std()-XYZ
timeBodyGyroJerk-std()-XYZ
timeBodyAccMag-std()
timeGravityAccMag-std()
timeBodyAccJerkMag-std()
timeBodyGyroMag-std()
timeBodyGyroJerkMag-std()
freqBodyAcc-std()-XYZ
freqBodyAccJerk-std()-XYZ
freqBodyGyro-std()-XYZ
freqBodyAccMag-std()
freqBodyBodyAccJerkMag-std()
freqBodyBodyGyroMag-std()
freqBodyBodyGyroJerkMag-std()


##Activity names
Although I hope theyare quite descriptive, I will include here the full length activity names.

laying            - laying
sitting           - sitting
standing          - standing
walking           - walking
walking_downsts   - walking_downstairs
walking_upsts     - walking_upstairs
