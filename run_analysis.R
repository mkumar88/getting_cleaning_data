x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
activity_labels <- read.table("activity_labels.txt")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
features <- read.table("features.txt")

#Merge the training and test data of x, y and subject
x <- rbind (x_test,x_train)
y <- rbind (y_test,y_train)
subject <- rbind (subject_test,subject_train)


#To make sense of the data, name the columns of x
colnames(x) <- features$V2

#Merge subject, y and x together into one unified dataset
#Ensure column names are corrected
proj_dataset <- cbind(subject,y,x)
colnames(proj_dataset)[1] <- "subject"
colnames(proj_dataset)[2] <- "activitycode"

#remove the unnecessary variables
rm(x,y,subject,x_train,x_test,y_train,y_test,subject_test,subject_train)

#Mean and standard deviation
#A read through the column names gives us the following rules:

#columns with "mean()" are clearly means as per the documentation provided

#columns with "mean" usually represent mean frequencies.
#It is possible that the mean frequency of each measurement is also important to understand the data, so these have been considered
#e.g. fBodyBodyAccJerkMag-meanFreq() is the mean frequency

#columns with "Mean" don't seem to contain the mean, so are excluded. 
#e.g. angle(X,gravityMean) is a measure of the angle between X and mean gravity, not the mean of the angle itself

#Columns with standard deviation contain "std"

#We now filter out only the column names with the mean and standard deviation, and store this output in x_measure
data_measure <- proj_dataset[,grepl("mean|std",colnames(proj_dataset))]
#Add back the subject and y columns into data_measure
data_measure <- cbind(proj_dataset[,1:2],data_measure)

#Look up the activity names into a new column, remove the activity code, and re-order data_measure to make activityname the 2nd column
data_measure$activityname <- activity_labels$V2[match(data_measure$activitycode,activity_labels$V1)]
data_measure <- data_measure[,c(1,82,3:81)]

#Cleaning the column names
#replace the columns starting with a t to start with time.
colnames(data_measure) <- gsub("^t","time.",colnames(data_measure))

#replace the columns starting with a f to start with freq.
colnames(data_measure) <- gsub("^f","freq.",colnames(data_measure))

#Remove parentheses from all column names
colnames(data_measure) <- gsub("[()]","",colnames(data_measure))

#replace "-" with "." in all column names
colnames(data_measure) <- gsub("-",".",colnames(data_measure))

#I notice column names in the freq. section with an unnecessary repetition of the word "Body"
#e.g. freq.BodyBodyGyroMag.std. This needs to be corrected to "freq.BodyGyroMag.std"
colnames(data_measure) <- gsub("BodyBody","Body",colnames(data_measure))

#now all column names are in the format:
#freq/time.MetricName.mean/std.X/Y/Z(optional)
#the capitalisation of words within the MetricName is needed, 
#since the metric names are composed of multiple words e.g. BodyGyroJerkMag

#Creating the new tidy data set with the average of each variable for each activity and each subject
data_summary <- data_measure %>% group_by(subject,activityname) %>% summarise_all(funs(mean))

#Creating the output file for the tidy data
write.table(data_summary,"Project_Tidy Data.txt")





