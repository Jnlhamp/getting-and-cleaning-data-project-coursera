library(dplyr)

# Step 1
# read in data files

xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjtrain <- read.table("train/subject_train.txt")

xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjtest <- read.table("test/subject_test.txt")

## add column name for subject files
names(subjtrain) <- "subjectID"
names(subjtest) <- "subjectID"

# add column names for measurement files
featureNames <- read.table("features.txt")
names(xtrain) <- featureNames$V2
names(xtest) <- featureNames$V2

# add column name for label files
names(ytrain) <- "activity"
names(ytest) <- "activity"


# Merge the training and test sets to create one data set
# create 'x' data set
xdata <- rbind(xtrain, xtest)
# add names to column headers
features<-read.table("features.txt")

names(xdata) <- features$V2

# create 'y' data set
ydata <- rbind(ytrain, ytest)

# create 'subject' data set
subjdata <- rbind(subjtrain, subjtest)

# create one master set called xdata
xdata <- cbind(subjdata, ydata, xdata)


# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement

meanandstd<-xdata[grep("mean[^A-Z]|std[^A-Z]|subjectID|activity", names(xdata))]

#meanandstd$activityId<-xdata$activity

#Step 3
#Use descriptive activity names to name the activities in the data set
#import activity_lables
activitylabel<-read.table(("activity_labels.txt"), header=FALSE)

#add activity names to meanandstd data set
activitynames <- merge(meanandstd, activitylabel, by.x="activity", by.y="V1")

#Step 4
#add descriptive column names
names(activitynames)<-gsub("^f", "frequency", names(activitynames))
names(activitynames)<-gsub("^t", "time", names(activitynames))
names(activitynames)<-gsub("std", "StDev", names(activitynames))
names(activitynames)<-gsub("Acc", "Acceleration", names(activitynames))
names(activitynames)<-gsub("Gyro", "Gyroscope", names(activitynames))
names(activitynames)<-gsub("Mag", "Magnitude", names(activitynames))
names(activitynames)<-gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body", names(activitynames))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## Fix this line

tidyresult<-aggregate(. ~activity + subjectID, activitynames, mean)

# Write table containing the final tidy result
write.table(tidyresult, "tidy_result.txt", row.name=FALSE)

