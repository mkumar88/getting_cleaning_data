## Course Project - Getting and Cleaning Data

Kruthika Kumar Muralidharan

### Background
A full description of the data used in this project can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

[Source data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Attribute Information
For each record in the dataset the following data is provided: 
- A 561-feature vector with time and frequency domain variables (*the measurements*)
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### Section 1. Merge the training and the test sets to create one data set.
After setting the source directory for the files, read into tables the data located in
* x_test.txt
* y_test.txt
* x_train.txt
* y_train.txt 
* subject_train.txt
* subject_test.txt
* features.txt
* activity_labels.txt

Steps:
1. Merge (by rows) x_test and x_train (to x), y_test and y_train (to y), subject_test and subject_train (to subject).
1. Look up column names for x from the *features* data
1. Now merge (by columns) the resultant x, y and subject variable - call this *proj_dataset*


### Section 2. Extract only the measurements on the mean and standard deviation for each measurement. 
Steps
1. Identify the relevant keywords for mean and std. deviation.
    - for mean, *mean()* and *mean* are variables that are relevant, so use *mean*
    - For standard deviation, *std* is the keyword
1. Use **grepl** to subset *proj_dataset* based on the keywords mentioned above, to create *data_measure*


### Section 3. Use descriptive activity names to name the activities in the data set
Match the activitycode in *data_measure* with *activity_labels* to include the descriptive activity names

### Section 4. Appropriately label the data set with descriptive activity names.
Use **gsub** to clean up the data labels.
Changes:
1. Replace the columns starting with a **t** to start with time.
1. Replace the columns starting with a **f** to start with freq.
1. Remove parentheses from all column names
1. Replace "-" with "." in all column names
1. Correct column names in the freq. section with an unnecessary repetition of the word "Body", e.g. *freq.BodyBodyGyroMag.std* corrected to *freq.BodyGyroMag.std*

Now all column names are in the format:
**freq/time.MetricName.mean/std.X/Y/Z(optional)**

### Section 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
1. Use the **summary_all** function to create the new tidy data set with the average of each variable for each activity and each subject
1. Use the **write.table** function to write the output into a *.txt* file

